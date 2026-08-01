import 'package:meta/meta.dart';

/// Identifies the JSON Schema node types understood by this generator.
///
/// The initial release supports this deliberately small subset so each schema
/// type has a predictable Dart representation. Unsupported JSON Schema
/// constructs are rejected while parsing instead of being silently ignored.
enum JsonSchemaType {
  reference,
  object,
  array,
  string,
  number,
  integer,
  boolean,
}

/// Stores one validated JSON Schema node in a generator-friendly form.
///
/// The node represents only the supported JSON Schema subset and retains
/// nullability, child properties, array items, and enum values needed by Dart
/// renderers. It is not a general-purpose JSON Schema model.
@immutable
class JsonSchemaNode {
  /// Creates an immutable parsed JSON Schema node.
  ///
  /// Parser-produced nodes provide a [type] and [isNullable]; other fields are
  /// populated only when they apply to that node type.
  factory JsonSchemaNode({
    required JsonSchemaType type,
    required bool isNullable,
    String? referenceName,
    Map<String, JsonSchemaNode> properties = const <String, JsonSchemaNode>{},
    Set<String> requiredProperties = const <String>{},
    JsonSchemaNode? items,
    List<Object?> enumValues = const <Object?>[],
  }) => JsonSchemaNode._(
    type: type,
    isNullable: isNullable,
    referenceName: referenceName,
    properties: Map<String, JsonSchemaNode>.unmodifiable(properties),
    requiredProperties: Set<String>.unmodifiable(requiredProperties),
    items: items,
    enumValues: List<Object?>.unmodifiable(enumValues),
  );

  JsonSchemaNode._({
    required this.type,
    required this.isNullable,
    required this.referenceName,
    required this.properties,
    required this.requiredProperties,
    required this.items,
    required this.enumValues,
  });

  /// The supported JSON Schema type represented by this node.
  final JsonSchemaType type;

  /// Whether the schema permits `null` in addition to [type].
  final bool isNullable;

  /// The target definition name when [type] is [JsonSchemaType.reference].
  final String? referenceName;

  /// Object properties keyed by their JSON field name.
  ///
  /// This is non-empty only for object schemas that declare properties.
  final Map<String, JsonSchemaNode> properties;

  /// The subset of [properties] required by an object schema.
  final Set<String> requiredProperties;

  /// The element schema for an array node.
  final JsonSchemaNode? items;

  /// The allowed enum literals when the schema declares an `enum` keyword.
  final List<Object?> enumValues;
}

/// Parses and resolves the local `$defs` JSON Schema document used by a manifest.
///
/// It validates supported schema shapes and every local `$ref` before exposing
/// nodes. That lets code generators rely on [definition] without rechecking
/// missing or circular references.
@immutable
class JsonSchemaDocument {
  JsonSchemaDocument._(Map<String, JsonSchemaNode> definitions)
    : definitions = Map<String, JsonSchemaNode>.unmodifiable(definitions);

  /// Builds a validated document from a manifest's `$defs` mapping.
  ///
  /// Each definition is parsed into [JsonSchemaNode], then local references are
  /// checked for existence and cycles. Invalid input throws [FormatException].
  factory JsonSchemaDocument.fromDefinitions(Map<String, Object?> definitions) {
    final parsed = <String, JsonSchemaNode>{};
    for (final entry in definitions.entries) {
      if (entry.value is! Map<String, Object?>) {
        throw FormatException(r'$defs.' + entry.key + ' must be an object.');
      }
      parsed[entry.key] = _parseNode(
        entry.value as Map<String, Object?>,
        location: r'$defs.' + entry.key,
      );
    }
    final document = JsonSchemaDocument._(parsed);
    document._validateReferences();
    return document;
  }

  /// Parsed local definitions keyed by their `$defs` name.
  ///
  /// The map is the source used to resolve JSON parameter schemas.
  final Map<String, JsonSchemaNode> definitions;

  /// Returns the parsed definition named [name].
  ///
  /// A missing name is a malformed manifest and produces [FormatException].
  JsonSchemaNode definition(String name) {
    final node = definitions[name];
    if (node == null) {
      throw FormatException(r'$defs.' + name + ' does not exist.');
    }
    return node;
  }

  static JsonSchemaNode _parseNode(
    Map<String, Object?> json, {
    required String location,
  }) {
    final rawReference = json[r'$ref'];
    if (rawReference != null) {
      if (rawReference is! String) {
        throw FormatException('$location.${r'$ref'} must be a string.');
      }
      return JsonSchemaNode(
        type: JsonSchemaType.reference,
        isNullable: false,
        referenceName: _referenceName(rawReference, location),
      );
    }

    final schemaType = _parseType(json['type'], location);
    final enumValues = _parseEnum(json['enum'], location);
    if (schemaType.type == JsonSchemaType.object) {
      return _parseObject(
        json,
        location: location,
        type: schemaType,
        enumValues: enumValues,
      );
    }
    if (schemaType.type == JsonSchemaType.array) {
      return _parseArray(
        json,
        location: location,
        type: schemaType,
        enumValues: enumValues,
      );
    }
    return JsonSchemaNode(
      type: schemaType.type,
      isNullable: schemaType.isNullable,
      enumValues: enumValues,
    );
  }

  static JsonSchemaNode _parseObject(
    Map<String, Object?> json, {
    required String location,
    required _SchemaType type,
    required List<Object?> enumValues,
  }) {
    final rawProperties = json['properties'];
    final properties = <String, JsonSchemaNode>{};
    if (rawProperties != null) {
      if (rawProperties is! Map<String, Object?>) {
        throw FormatException('$location.properties must be an object.');
      }

      for (final entry in rawProperties.entries) {
        if (entry.value is! Map<String, Object?>) {
          throw FormatException(
            '$location.properties.${entry.key} must be an object.',
          );
        }
        properties[entry.key] = _parseNode(
          entry.value as Map<String, Object?>,
          location: '$location.properties.${entry.key}',
        );
      }
    }

    return JsonSchemaNode(
      type: JsonSchemaType.object,
      isNullable: type.isNullable,
      properties: properties,
      requiredProperties: _parseRequired(
        json['required'],
        location,
        properties,
      ),
      enumValues: enumValues,
    );
  }

  static JsonSchemaNode _parseArray(
    Map<String, Object?> json, {
    required String location,
    required _SchemaType type,
    required List<Object?> enumValues,
  }) {
    final rawItems = json['items'];
    if (rawItems is! Map<String, Object?>) {
      throw FormatException(
        '$location.items must be an object for array schemas.',
      );
    }

    return JsonSchemaNode(
      type: JsonSchemaType.array,
      isNullable: type.isNullable,
      items: _parseNode(rawItems, location: '$location.items'),
      enumValues: enumValues,
    );
  }

  static Set<String> _parseRequired(
    Object? rawRequired,
    String location,
    Map<String, JsonSchemaNode> properties,
  ) {
    if (rawRequired == null) {
      return <String>{};
    }
    if (rawRequired is! List<Object?> ||
        rawRequired.any((Object? value) => value is! String)) {
      throw FormatException('$location.required must be an array of strings.');
    }

    final required = rawRequired.cast<String>().toSet();
    final unknown = required.difference(properties.keys.toSet());
    if (unknown.isNotEmpty) {
      throw FormatException(
        '$location.required contains undefined properties: ${unknown.join(', ')}.',
      );
    }
    return required;
  }

  static _SchemaType _parseType(Object? rawType, String location) {
    final types = switch (rawType) {
      String type => <String>[type],
      List<Object?> values
          when values.every((Object? value) => value is String) =>
        values.cast<String>(),
      _ => throw FormatException(
        '$location.type must be a string or an array of strings.',
      ),
    };
    final nullable = types.remove('null');
    if (types.length != 1) {
      throw FormatException(
        '$location.type must contain one supported type, optionally with null.',
      );
    }

    final type = switch (types.single) {
      'object' => JsonSchemaType.object,
      'array' => JsonSchemaType.array,
      'string' => JsonSchemaType.string,
      'number' => JsonSchemaType.number,
      'integer' => JsonSchemaType.integer,
      'boolean' => JsonSchemaType.boolean,
      _ => null,
    };
    if (type == null) {
      throw FormatException(
        '$location.type contains unsupported type ${types.single}.',
      );
    }
    return _SchemaType(type: type, isNullable: nullable);
  }

  static List<Object?> _parseEnum(Object? rawEnum, String location) {
    if (rawEnum == null) {
      return const <Object?>[];
    }
    if (rawEnum is! List<Object?> || rawEnum.isEmpty) {
      throw FormatException('$location.enum must be a non-empty array.');
    }

    return List<Object?>.unmodifiable(rawEnum);
  }

  static String _referenceName(String reference, String location) {
    const prefix = r'#/$defs/';
    if (!reference.startsWith(prefix) ||
        reference.substring(prefix.length).contains('/')) {
      throw FormatException(
        '$location.${r'$ref'} must be a local $prefix reference.',
      );
    }

    return reference.substring(prefix.length);
  }

  void _validateReferences() {
    for (final node in definitions.values) {
      _visit(node, <String>{});
    }
  }

  void _visit(JsonSchemaNode node, Set<String> path) {
    if (node.type == JsonSchemaType.reference) {
      final referenceName = node.referenceName!;
      if (!definitions.containsKey(referenceName)) {
        throw FormatException(
          r'$ref points to an undefined definition: ' + referenceName,
        );
      }
      if (!path.add(referenceName)) {
        throw FormatException(
          'Circular ${r'$ref'} is not supported in the first release: ${path.join(' -> ')}.',
        );
      }
      _visit(definition(referenceName), path);
      path.remove(referenceName);
      return;
    }
    for (final JsonSchemaNode property in node.properties.values) {
      _visit(property, Set<String>.from(path));
    }
    if (node.items case final JsonSchemaNode items) {
      _visit(items, Set<String>.from(path));
    }
  }
}

class _SchemaType {
  const _SchemaType({required this.type, required this.isNullable});

  final JsonSchemaType type;
  final bool isNullable;
}
