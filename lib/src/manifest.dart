import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import 'json_schema.dart';

/// Represents the human-maintained, language-neutral Remote Config manifest.
///
/// A manifest declares Firebase parameter keys, their value types and default
/// values, plus local JSON Schema definitions for `JSON` parameters. It is the
/// validated source of input for the Dart generator.
@immutable
class Manifest {
  /// Creates an already validated manifest.
  ///
  /// Most callers should use [Manifest.fromJson] or [Manifest.read] so the
  /// parameter and JSON Schema relationships are checked before generation.
  Manifest._({
    required Map<String, RemoteConfigParameterDefinition> parameters,
    required Map<String, Object?> definitions,
    required this.schemaDocument,
  }) : parameters = Map<String, RemoteConfigParameterDefinition>.unmodifiable(
         parameters,
       ),
       definitions = Map<String, Object?>.unmodifiable(definitions);

  /// Parses and validates a manifest from decoded JSON.
  ///
  /// The input must define non-empty `parameters`; JSON parameter references
  /// are resolved against `$defs`. Violations throw [FormatException].
  factory Manifest.fromJson(Map<String, Object?> json) {
    final rawParameters = json['parameters'];
    if (rawParameters is! Map<String, Object?> || rawParameters.isEmpty) {
      throw const FormatException(
        'parameters must be a non-empty object keyed by parameter name.',
      );
    }

    final parameters = <String, RemoteConfigParameterDefinition>{};
    for (final entry in rawParameters.entries) {
      if (entry.value is! Map<String, Object?>) {
        throw FormatException('parameters.${entry.key} must be an object.');
      }
      parameters[entry.key] = RemoteConfigParameterDefinition.fromJson(
        entry.key,
        entry.value as Map<String, Object?>,
      );
    }

    final rawDefinitions = json[r'$defs'];
    if (rawDefinitions != null && rawDefinitions is! Map<String, Object?>) {
      throw const FormatException(r'$defs must be an object when supplied.');
    }
    final definitions =
        rawDefinitions as Map<String, Object?>? ?? <String, Object?>{};

    final manifest = Manifest._(
      parameters: parameters,
      definitions: definitions,
      schemaDocument: JsonSchemaDocument.fromDefinitions(definitions),
    );
    manifest._validateReferences();
    return manifest;
  }

  /// Reads, decodes, and validates a manifest JSON [file].
  ///
  /// Missing files throw [FileSystemException]. JSON syntax errors and invalid
  /// manifest content are reported as [FormatException].
  static Future<Manifest> read(File file) async {
    if (!await file.exists()) {
      throw FileSystemException('Remote Config manifest not found', file.path);
    }

    try {
      final decodedJson = jsonDecode(await file.readAsString());
      if (decodedJson is! Map<String, Object?>) {
        throw const FormatException('The manifest root must be a JSON object.');
      }
      return Manifest.fromJson(decodedJson);
    } on FormatException {
      rethrow;
    } catch (error) {
      throw FormatException('Unable to parse ${file.path}: $error');
    }
  }

  /// Parameter definitions keyed by their Firebase Remote Config key.
  ///
  /// Generators use this map to emit typed accessors and their defaults.
  final Map<String, RemoteConfigParameterDefinition> parameters;

  /// The raw local JSON Schema definitions from the manifest's `$defs` field.
  ///
  /// This preserves the language-neutral input alongside [schemaDocument].
  final Map<String, Object?> definitions;

  /// The parsed representation of [definitions].
  ///
  /// It resolves local references and is used when generating Dart model types.
  final JsonSchemaDocument schemaDocument;

  void _validateReferences() {
    for (final parameter in parameters.values) {
      final reference = parameter.valueSchemaReference;
      if (reference == null) {
        continue;
      }
      const prefix = r'#/$defs/';
      if (!reference.startsWith(prefix)) {
        throw FormatException(
          'valueSchema $reference must use a local $prefix reference in the first release.',
        );
      }
      schemaDocument.definition(reference.substring(prefix.length));
    }
  }
}

/// Describes one Remote Config parameter declared in a [Manifest].
///
/// The definition retains the Firebase-compatible `valueType` and default
/// value. JSON parameters additionally point to a local JSON Schema definition
/// through [valueSchemaReference].
@immutable
class RemoteConfigParameterDefinition {
  /// Creates a validated parameter definition.
  RemoteConfigParameterDefinition._({
    required this.key,
    required this.valueType,
    required Object? defaultValue,
    required this.valueSchemaReference,
  }) : defaultValue = _freezeJsonValue(defaultValue);

  /// Parses and validates a parameter definition for [key].
  ///
  /// The accepted value types match Firebase Remote Config's primitive and JSON
  /// parameter types supported by this package. Invalid defaults or schema
  /// references throw [FormatException].
  factory RemoteConfigParameterDefinition.fromJson(
    String key,
    Map<String, Object?> json,
  ) {
    final rawValueType = json['valueType'];
    if (rawValueType is! String ||
        !_supportedValueTypes.contains(rawValueType)) {
      throw FormatException(
        'parameters.$key.valueType must be STRING, BOOLEAN, NUMBER, or JSON.',
      );
    }

    if (!json.containsKey('defaultValue')) {
      throw FormatException('parameters.$key.defaultValue is required.');
    }
    final defaultValue = json['defaultValue'];
    final isValueTypeValid = switch (rawValueType) {
      'STRING' => defaultValue is String,
      'BOOLEAN' => defaultValue is bool,
      'NUMBER' => defaultValue is num,
      'JSON' =>
        defaultValue is Map<String, Object?> || defaultValue is List<Object?>,
      _ => false,
    };
    if (!isValueTypeValid) {
      throw FormatException(
        'parameters.$key.defaultValue does not match $rawValueType.',
      );
    }

    final rawSchema = json['valueSchema'];
    String? reference;
    if (rawValueType == 'JSON') {
      if (rawSchema is! Map<String, Object?> || rawSchema[r'$ref'] is! String) {
        throw FormatException(
          'parameters.$key.valueSchema must contain a ${r'$ref'} for JSON values.',
        );
      }
      reference = rawSchema[r'$ref'] as String;
    } else if (rawSchema != null) {
      throw FormatException(
        'parameters.$key.valueSchema is only valid for JSON values.',
      );
    }

    return RemoteConfigParameterDefinition._(
      key: key,
      valueType: rawValueType,
      defaultValue: defaultValue,
      valueSchemaReference: reference,
    );
  }

  static const Set<String> _supportedValueTypes = <String>{
    'STRING',
    'BOOLEAN',
    'NUMBER',
    'JSON',
  };

  static Object? _freezeJsonValue(Object? value) => switch (value) {
    Map<String, Object?> map => Map<String, Object?>.unmodifiable(
      map.map(
        (key, value) => MapEntry<String, Object?>(key, _freezeJsonValue(value)),
      ),
    ),
    List<Object?> list => List<Object?>.unmodifiable(
      list.map(_freezeJsonValue),
    ),
    _ => value,
  };

  /// The Firebase Remote Config parameter key.
  final String key;

  /// The Firebase-compatible value type: `STRING`, `BOOLEAN`, `NUMBER`, or `JSON`.
  final String valueType;

  /// The manifest default used to validate configuration and JSON fallbacks.
  final Object? defaultValue;

  /// The local `$defs` reference for a JSON parameter, if one is required.
  ///
  /// Non-JSON parameters always have `null` here.
  final String? valueSchemaReference;
}
