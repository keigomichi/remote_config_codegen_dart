import 'dart:io';

import 'package:remote_config_codegen/remote_config_codegen.dart';
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

    test('fromJson accepts a manifest containing only parameter groups', () {
      final manifest = Manifest.fromJson(<String, Object?>{
        'parameterGroups': <String, Object?>{
          'Search V2': <String, Object?>{
            'description': 'New mobile search view',
            'parameters': <String, Object?>{
              'search_enabled': <String, Object?>{
                'valueType': 'BOOLEAN',
                'defaultValue': false,
              },
            },
          },
        },
      });

      expect(manifest.parameters, isEmpty);
      expect(manifest.parameterGroups, contains('Search V2'));
      expect(
        manifest.parameterGroups['Search V2']!.description,
        'New mobile search view',
      );
      expect(
        manifest
            .parameterGroups['Search V2']!
            .parameters['search_enabled']!
            .defaultValue,
        isFalse,
      );
    });

    test('fromJson rejects duplicate parameter keys across locations', () {
      expect(
        () => Manifest.fromJson(<String, Object?>{
          'parameters': <String, Object?>{
            'shared_key': <String, Object?>{
              'valueType': 'STRING',
              'defaultValue': 'top-level',
            },
          },
          'parameterGroups': <String, Object?>{
            'Group': <String, Object?>{
              'parameters': <String, Object?>{
                'shared_key': <String, Object?>{
                  'valueType': 'STRING',
                  'defaultValue': 'grouped',
                },
              },
            },
          },
        }),
        throwsFormatException,
      );
    });

    test('fromJson rejects empty and invalid parameter groups', () {
      expect(
        () => Manifest.fromJson(<String, Object?>{}),
        throwsFormatException,
      );
      expect(
        () => Manifest.fromJson(<String, Object?>{
          'parameterGroups': <String, Object?>{
            'Empty': <String, Object?>{'parameters': <String, Object?>{}},
          },
        }),
        throwsFormatException,
      );
      expect(
        () => Manifest.fromJson(<String, Object?>{
          'parameterGroups': <String, Object?>{
            '日本語': <String, Object?>{
              'parameters': <String, Object?>{
                'enabled': <String, Object?>{
                  'valueType': 'BOOLEAN',
                  'defaultValue': false,
                },
              },
            },
          },
        }),
        throwsFormatException,
      );
    });

    test('fromJson validates parameter group name and description lengths', () {
      Map<String, Object?> groupedManifest(String name, Object? description) =>
          <String, Object?>{
            'parameterGroups': <String, Object?>{
              name: <String, Object?>{
                'description': description,
                'parameters': <String, Object?>{
                  'enabled': <String, Object?>{
                    'valueType': 'BOOLEAN',
                    'defaultValue': false,
                  },
                },
              },
            },
          };

      expect(
        () => Manifest.fromJson(
          groupedManifest(List<String>.filled(257, 'a').join(), 'description'),
        ),
        throwsFormatException,
      );
      expect(
        () => Manifest.fromJson(
          groupedManifest('Group', List<String>.filled(257, 'a').join()),
        ),
        throwsFormatException,
      );
      expect(
        () => Manifest.fromJson(groupedManifest('Group', 42)),
        throwsFormatException,
      );
    });

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
