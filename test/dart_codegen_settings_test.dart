import 'dart:io';

import 'package:remote_config_codegen/remote_config_codegen_dart.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('DartCodegenSettings', () {
    group('fromYaml', () {
      test('uses defaults when serializer and class name are omitted', () {
        final settings = DartCodegenSettings.fromYaml(
          loadYaml('''
dart:
  output_directory: lib/generated
'''),
        );

        expect(settings.remoteConfigClientClassName, 'RemoteConfigClient');
        expect(settings.serializer, DartSerializer.jsonSerializable);
      });

      test('uses the serializer selected in YAML', () {
        final settings = DartCodegenSettings.fromYaml(
          loadYaml('''
dart:
  output_directory: lib/generated
  serializer: freezed
'''),
        );

        expect(settings.serializer, DartSerializer.freezed);
      });

      test('rejects invalid mappings and client class names', () {
        expect(
          () => DartCodegenSettings.fromYaml(<String, Object?>{}),
          throwsFormatException,
        );
        expect(
          () => DartCodegenSettings.fromYaml(
            loadYaml('''
dart:
  output_directory: ''
'''),
          ),
          throwsFormatException,
        );
        expect(
          () => DartCodegenSettings.fromYaml(
            loadYaml('''
dart:
  output_directory: generated
  remote_config_client_class_name: remoteConfig
'''),
          ),
          throwsFormatException,
        );
      });
    });

    group('read', () {
      test('loads settings from a YAML file', () async {
        final directory = await Directory.systemTemp.createTemp(
          'rcc-settings-',
        );
        addTearDown(() => directory.delete(recursive: true));
        final file = File('${directory.path}/remote_config_codegen.yaml');
        await file.writeAsString('''
dart:
  output_directory: generated
  remote_config_client_class_name: AppRemoteConfig
''');

        final settings = await DartCodegenSettings.read(file);

        expect(settings.outputDirectory, 'generated');
        expect(settings.remoteConfigClientClassName, 'AppRemoteConfig');
      });

      test('rejects a missing settings file', () async {
        final file = File('${Directory.systemTemp.path}/missing-settings.yaml');

        expect(
          DartCodegenSettings.read(file),
          throwsA(isA<FileSystemException>()),
        );
      });

      test('wraps malformed YAML as a format error', () async {
        final directory = await Directory.systemTemp.createTemp(
          'rcc-settings-',
        );
        addTearDown(() => directory.delete(recursive: true));
        final file = File('${directory.path}/remote_config_codegen.yaml');
        await file.writeAsString('dart: [');

        expect(DartCodegenSettings.read(file), throwsFormatException);
      });
    });

    group('resolveOutputDirectory', () {
      test('resolves a relative path against the settings location', () {
        final settings = DartCodegenSettings.fromYaml(
          loadYaml('''
dart:
  output_directory: lib/generated
  serializer: json_serializable
'''),
        );

        expect(
          settings.resolveOutputDirectory(Directory('/tmp/example')).path,
          '/tmp/example${Platform.pathSeparator}lib${Platform.pathSeparator}generated',
        );
      });

      test('preserves an absolute path', () {
        final settings = DartCodegenSettings.fromYaml(
          loadYaml('''
dart:
  output_directory: /tmp/generated
'''),
        );

        expect(
          settings.resolveOutputDirectory(Directory('/tmp/example')).path,
          '/tmp/generated',
        );
      });
    });
  });
}
