import 'dart_codegen_settings.dart';
import 'dart_literal.dart';
import 'dart_names.dart';
import 'dart_type_resolver.dart';
import 'constants.dart';
import 'json_schema.dart';
import 'manifest.dart';

/// Renders the Firebase-backed typed Remote Config client source.
///
/// The renderer owns Firebase SDK calls, parameter key literals, and JSON
/// fallback behavior. It is separate from model renderers because those vary
/// by serializer while the initial client implementation is Firebase-specific.
class RemoteConfigClientRenderer {
  /// Creates a stateless Firebase Remote Config client renderer.
  const RemoteConfigClientRenderer();

  /// Renders a typed client from [manifest] using [settings] and [resolver].
  ///
  /// JSON parameters use [resolver] to select their generated model type and
  /// fall back to the manifest default when Firebase returns invalid JSON.
  String render(
    Manifest manifest,
    DartCodegenSettings settings,
    DartTypeResolver resolver,
  ) {
    final hasJsonParameter = manifest.parameters.values.any(
      (parameter) => parameter.valueType == 'JSON',
    );
    final buffer = StringBuffer(generatedCodeHeader)
      ..writeln(
        "import 'package:firebase_remote_config/firebase_remote_config.dart';",
      );
    if (hasJsonParameter) {
      buffer
        ..writeln("import 'dart:convert';")
        ..writeln()
        ..writeln("import 'remote_config_models.dart';");
    }
    buffer
      ..writeln()
      ..writeln('class ${settings.remoteConfigClientClassName} {')
      ..writeln(
        '  const ${settings.remoteConfigClientClassName}(this._remoteConfig);',
      )
      ..writeln()
      ..writeln('  final FirebaseRemoteConfig _remoteConfig;')
      ..writeln();

    final parameters = manifest.parameters.values.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final parameter in parameters) {
      _renderParameterMethods(
        buffer,
        parameter,
        DartNames.type(parameter.key),
        "'${DartLiteral.string(parameter.key)}'",
        manifest,
        resolver,
      );
    }
    buffer.writeln('}');
    return buffer.toString();
  }

  void _renderParameterMethods(
    StringBuffer buffer,
    RemoteConfigParameterDefinition parameter,
    String baseName,
    String keyLiteral,
    Manifest manifest,
    DartTypeResolver resolver,
  ) {
    switch (parameter.valueType) {
      case 'BOOLEAN':
        buffer.writeln(
          '  bool get$baseName() => _remoteConfig.getBool($keyLiteral);',
        );
      case 'STRING':
        buffer.writeln(
          '  String get$baseName() => _remoteConfig.getString($keyLiteral);',
        );
      case 'NUMBER':
        buffer
          ..writeln(
            '  int get${baseName}Int() => _remoteConfig.getInt($keyLiteral);',
          )
          ..writeln(
            '  double get${baseName}Double() => _remoteConfig.getDouble($keyLiteral);',
          );
      case 'JSON':
        _renderJsonMethod(
          buffer,
          parameter,
          baseName,
          keyLiteral,
          manifest,
          resolver,
        );
      default:
        throw StateError('Unexpected value type ${parameter.valueType}.');
    }
    buffer.writeln();
  }

  void _renderJsonMethod(
    StringBuffer buffer,
    RemoteConfigParameterDefinition parameter,
    String baseName,
    String keyLiteral,
    Manifest manifest,
    DartTypeResolver resolver,
  ) {
    final reference = parameter.valueSchemaReference!;
    final definitionName = reference.substring(r'#/$defs/'.length);
    final root = manifest.schemaDocument.definition(definitionName);
    if (root.type != JsonSchemaType.object) {
      throw FormatException(
        'JSON parameter ${parameter.key} must reference an object definition.',
      );
    }
    final type = resolver.typeFor(root);
    final defaultValue = DartLiteral.value(parameter.defaultValue);
    buffer
      ..writeln('  $type get$baseName() {')
      ..writeln('    try {')
      ..writeln(
        '      final Object? decoded = jsonDecode(_remoteConfig.getString($keyLiteral));',
      )
      ..writeln('      if (decoded is! Map<String, dynamic>) {')
      ..writeln(
        "        throw const FormatException('Expected a JSON object.');",
      )
      ..writeln('      }')
      ..writeln('      return $type.fromJson(decoded);')
      ..writeln('    } on Object {')
      ..writeln('      return $type.fromJson($defaultValue);')
      ..writeln('    }')
      ..writeln('  }');
  }
}
