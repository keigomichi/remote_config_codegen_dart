import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'dart_serializer.dart';

/// Describes how Dart source files are generated.
///
/// These settings intentionally live outside the Remote Config manifest: the
/// manifest is language-neutral input, while this class contains Dart-specific
/// output paths, serializer choices, and the generated client class name.
@immutable
class DartCodegenSettings {
  /// Creates settings that control the generated Dart files.
  ///
  /// [outputDirectory] is required because it determines where the generator
  /// writes files. [serializer] defaults to [DartSerializer.jsonSerializable]
  /// to match the default selected by the YAML configuration format.
  DartCodegenSettings._({
    required this.outputDirectory,
    required this.serializer,
    required this.remoteConfigClientClassName,
  });

  /// The client class name used when YAML does not specify one.
  ///
  /// It is public so tools that create configuration files can use the same
  /// default without duplicating the literal.
  static const String _defaultClientClassName = 'RemoteConfigClient';

  /// Parses Dart generation settings from a decoded YAML value.
  ///
  /// The expected shape is a root mapping with a `dart` mapping. Invalid
  /// output paths, serializers, or client class names throw [FormatException]
  /// before any files are written.
  factory DartCodegenSettings.fromYaml(Object? yaml) {
    if (yaml is! YamlMap) {
      throw const FormatException('The YAML root must be a mapping.');
    }

    final dart = yaml['dart'];
    if (dart is! YamlMap) {
      throw const FormatException('dart must be a mapping.');
    }

    final outputDirectory = dart['output_directory'];
    if (outputDirectory is! String || outputDirectory.isEmpty) {
      throw const FormatException(
        'dart.output_directory must be a non-empty string.',
      );
    }
    final serializer = dart['serializer'] == null
        ? DartSerializer.jsonSerializable
        : DartSerializer.parse(dart['serializer']);

    final className = switch (dart['remote_config_client_class_name']) {
      null => _defaultClientClassName,
      String value => value,
      _ => throw const FormatException(
        'dart.remote_config_client_class_name must be a valid PascalCase Dart class name.',
      ),
    };
    if (!RegExp(r'^[A-Z][A-Za-z0-9]*$').hasMatch(className)) {
      throw const FormatException(
        'dart.remote_config_client_class_name must be a valid PascalCase Dart class name.',
      );
    }

    return DartCodegenSettings._(
      outputDirectory: outputDirectory,
      serializer: serializer,
      remoteConfigClientClassName: className,
    );
  }

  /// Reads and parses settings from [file].
  ///
  /// Missing files produce [FileSystemException], while malformed YAML or an
  /// invalid settings shape produces [FormatException].
  static Future<DartCodegenSettings> read(File file) async {
    if (!await file.exists()) {
      throw FileSystemException(
        'Dart generation settings not found',
        file.path,
      );
    }
    try {
      final yaml = loadYaml(await file.readAsString());
      return DartCodegenSettings.fromYaml(yaml);
    } on YamlException catch (error) {
      throw FormatException('Unable to parse ${file.path}: ${error.message}');
    }
  }

  /// The absolute or settings-relative directory for generated files.
  ///
  /// Relative paths are resolved by [resolveOutputDirectory].
  final String outputDirectory;

  /// The annotation-based model serializer used by generated JSON models.
  ///
  /// The selected value determines both imports and the rendered model shape.
  final DartSerializer serializer;

  /// The public class name emitted for the typed Remote Config client.
  ///
  /// The value is validated as a PascalCase Dart identifier during parsing.
  final String remoteConfigClientClassName;

  /// Resolves [outputDirectory] to the directory where files will be written.
  ///
  /// Absolute paths are returned unchanged. Relative paths are interpreted
  /// relative to [settingsDirectory], rather than the current process path.
  Directory resolveOutputDirectory(Directory settingsDirectory) {
    if (File(outputDirectory).isAbsolute) {
      return Directory(outputDirectory);
    }
    return Directory(
      '${settingsDirectory.path}${Platform.pathSeparator}$outputDirectory',
    );
  }
}
