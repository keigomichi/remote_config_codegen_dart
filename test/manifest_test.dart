import 'dart:io';

import 'package:remote_config_codegen/remote_config_codegen_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Manifest', () {
    test(
      'fromJson accepts JSON parameters that refer to a local definition',
      () {
        final manifest = Manifest.fromJson(<String, Object?>{
          'parameters': <String, Object?>{
            'app_banner': <String, Object?>{
              'valueType': 'JSON',
              'defaultValue': <String, Object?>{'items': <Object?>[]},
              'valueSchema': <String, Object?>{r'$ref': r'#/$defs/Banner'},
            },
          },
          r'$defs': <String, Object?>{
            'Banner': <String, Object?>{'type': 'object'},
          },
        });

        expect(
          manifest.parameters['app_banner']!.valueSchemaReference,
          r'#/$defs/Banner',
        );
      },
    );

    test(
      'fromJson rejects a boolean parameter whose default value is not boolean',
      () {
        expect(
          () => Manifest.fromJson(<String, Object?>{
            'parameters': <String, Object?>{
              'app_enabled': <String, Object?>{
                'valueType': 'BOOLEAN',
                'defaultValue': 'false',
              },
            },
          }),
          throwsFormatException,
        );
      },
    );

    test('read loads a manifest JSON file', () async {
      final directory = await Directory.systemTemp.createTemp('rcc-manifest-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/config.json');
      await file.writeAsString('''
{
  "parameters": {
    "app_enabled": { "valueType": "BOOLEAN", "defaultValue": false }
  }
}
''');

      final manifest = await Manifest.read(file);

      expect(manifest.parameters['app_enabled']!.defaultValue, isFalse);
    });

    test('read reports missing files and malformed JSON', () async {
      final directory = await Directory.systemTemp.createTemp('rcc-manifest-');
      addTearDown(() => directory.delete(recursive: true));

      await expectLater(
        Manifest.read(File('${directory.path}/missing.json')),
        throwsA(isA<FileSystemException>()),
      );

      final malformed = File('${directory.path}/malformed.json');
      await malformed.writeAsString('{');
      await expectLater(Manifest.read(malformed), throwsFormatException);
    });

    test('fromJson rejects invalid parameter entries and definitions', () {
      expect(
        () => Manifest.fromJson(<String, Object?>{
          'parameters': <String, Object?>{'app_enabled': false},
        }),
        throwsFormatException,
      );
      expect(
        () => Manifest.fromJson(<String, Object?>{
          'parameters': <String, Object?>{
            'app_enabled': <String, Object?>{
              'valueType': 'BOOLEAN',
              'defaultValue': false,
            },
          },
          r'$defs': <Object?>[],
        }),
        throwsFormatException,
      );
    });

    test('fromJson rejects a non-local JSON schema reference', () {
      expect(
        () => Manifest.fromJson(<String, Object?>{
          'parameters': <String, Object?>{
            'app_banner': <String, Object?>{
              'valueType': 'JSON',
              'defaultValue': <String, Object?>{},
              'valueSchema': <String, Object?>{r'$ref': '#/components/Banner'},
            },
          },
        }),
        throwsFormatException,
      );
    });
  });

  group('RemoteConfigParameterDefinition', () {
    test('fromJson accepts a string parameter without a value schema', () {
      final definition = RemoteConfigParameterDefinition.fromJson(
        'app_title',
        <String, Object?>{'valueType': 'STRING', 'defaultValue': 'Hello'},
      );

      expect(definition.key, 'app_title');
      expect(definition.valueType, 'STRING');
      expect(definition.valueSchemaReference, isNull);
    });

    test('fromJson rejects a non-JSON parameter with a value schema', () {
      expect(
        () => RemoteConfigParameterDefinition.fromJson(
          'app_title',
          <String, Object?>{
            'valueType': 'STRING',
            'defaultValue': 'Hello',
            'valueSchema': <String, Object?>{r'$ref': r'#/$defs/Title'},
          },
        ),
        throwsFormatException,
      );
    });

    test('fromJson rejects missing defaults and JSON schemas', () {
      expect(
        () => RemoteConfigParameterDefinition.fromJson(
          'app_enabled',
          <String, Object?>{'valueType': 'BOOLEAN'},
        ),
        throwsFormatException,
      );
      expect(
        () => RemoteConfigParameterDefinition.fromJson(
          'app_banner',
          <String, Object?>{
            'valueType': 'JSON',
            'defaultValue': <String, Object?>{},
          },
        ),
        throwsFormatException,
      );
    });

    test('fromJson rejects an unsupported value type', () {
      expect(
        () => RemoteConfigParameterDefinition.fromJson(
          'app_state',
          <String, Object?>{
            'valueType': 'OBJECT',
            'defaultValue': <String, Object?>{},
          },
        ),
        throwsFormatException,
      );
    });
  });
}
