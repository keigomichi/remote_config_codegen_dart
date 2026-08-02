import 'package:remote_config_codegen/remote_config_codegen.dart';
import 'package:remote_config_codegen/src/dart_model_registry.dart';
import 'package:remote_config_codegen/src/dart_type_resolver.dart';
import 'package:remote_config_codegen/src/remote_config_client_renderer.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('RemoteConfigClientRenderer', () {
    test('render emits typed Firebase getters with inline parameter keys', () {
      final manifest = Manifest.fromJson(<String, Object?>{
        'parameters': <String, Object?>{
          'app_enabled': <String, Object?>{
            'valueType': 'BOOLEAN',
            'defaultValue': false,
          },
          'app_title': <String, Object?>{
            'valueType': 'STRING',
            'defaultValue': 'Welcome',
          },
          'app_max_items': <String, Object?>{
            'valueType': 'NUMBER',
            'defaultValue': 3,
          },
          'app_banner': <String, Object?>{
            'valueType': 'JSON',
            'defaultValue': <String, Object?>{'title': 'Default'},
            'valueSchema': <String, Object?>{r'$ref': r'#/$defs/Banner'},
          },
        },
        r'$defs': <String, Object?>{
          'Banner': <String, Object?>{
            'type': 'object',
            'properties': <String, Object?>{},
          },
        },
      });
      final registry = DartModelRegistry.build(manifest.schemaDocument);
      final resolver = DartTypeResolver(manifest.schemaDocument, registry);
      final settings = DartCodegenSettings.fromYaml(
        loadYaml('''
dart:
  output_directory: generated
'''),
      );

      final source = const RemoteConfigClientRenderer().render(
        manifest,
        settings,
        resolver,
      );

      expect(source, contains("_remoteConfig.getBool('app_enabled')"));
      expect(source, contains("_remoteConfig.getString('app_title')"));
      expect(source, contains("_remoteConfig.getInt('app_max_items')"));
      expect(source, contains("_remoteConfig.getDouble('app_max_items')"));
      expect(source, contains("_remoteConfig.getString('app_banner')"));
      expect(source, contains("<String, dynamic>{'title': 'Default'}"));
      expect(source, isNot(contains('static const String')));
    });

    test(
      'render rejects JSON parameters that reference a non-object schema',
      () {
        final manifest = Manifest.fromJson(<String, Object?>{
          'parameters': <String, Object?>{
            'app_status': <String, Object?>{
              'valueType': 'JSON',
              'defaultValue': <String, Object?>{},
              'valueSchema': <String, Object?>{r'$ref': r'#/$defs/Status'},
            },
          },
          r'$defs': <String, Object?>{
            'Status': <String, Object?>{
              'type': 'string',
              'enum': <Object?>['active'],
            },
          },
        });
        final registry = DartModelRegistry.build(manifest.schemaDocument);

        expect(
          () => const RemoteConfigClientRenderer().render(
            manifest,
            DartCodegenSettings.fromYaml(
              loadYaml('dart:\n  output_directory: generated'),
            ),
            DartTypeResolver(manifest.schemaDocument, registry),
          ),
          throwsFormatException,
        );
      },
    );

    test('render prefixes grouped getters and preserves Firebase keys', () {
      final manifest = Manifest.fromJson(<String, Object?>{
        'parameterGroups': <String, Object?>{
          'Search V2': <String, Object?>{
            'description': 'New mobile search view',
            'parameters': <String, Object?>{
              'search_enabled': <String, Object?>{
                'valueType': 'BOOLEAN',
                'defaultValue': false,
              },
              'search_title': <String, Object?>{
                'valueType': 'STRING',
                'defaultValue': 'Search',
              },
              'search_limit': <String, Object?>{
                'valueType': 'NUMBER',
                'defaultValue': 10,
              },
              'search_layout': <String, Object?>{
                'valueType': 'JSON',
                'defaultValue': <String, Object?>{'columns': 1},
                'valueSchema': <String, Object?>{
                  r'$ref': r'#/$defs/SearchLayout',
                },
              },
            },
          },
        },
        r'$defs': <String, Object?>{
          'SearchLayout': <String, Object?>{
            'type': 'object',
            'required': <Object?>['columns'],
            'properties': <String, Object?>{
              'columns': <String, Object?>{'type': 'integer'},
            },
          },
        },
      });
      final registry = DartModelRegistry.build(manifest.schemaDocument);

      final source = const RemoteConfigClientRenderer().render(
        manifest,
        DartCodegenSettings.fromYaml(
          loadYaml('dart:\n  output_directory: generated'),
        ),
        DartTypeResolver(manifest.schemaDocument, registry),
      );

      expect(source, contains('/// New mobile search view'));
      expect(source, contains('bool getSearchV2SearchEnabled()'));
      expect(source, contains("_remoteConfig.getBool('search_enabled')"));
      expect(source, contains('String getSearchV2SearchTitle()'));
      expect(source, contains('int getSearchV2SearchLimitInt()'));
      expect(source, contains('double getSearchV2SearchLimitDouble()'));
      expect(source, contains('SearchLayout getSearchV2SearchLayout()'));
      expect(source, contains("_remoteConfig.getString('search_layout')"));
      expect(source, contains("<String, dynamic>{'columns': 1}"));
      expect(
        source.indexOf('getSearchV2SearchEnabled'),
        lessThan(source.indexOf('getSearchV2SearchLayout')),
      );
      expect(
        source.indexOf('getSearchV2SearchLayout'),
        lessThan(source.indexOf('getSearchV2SearchLimitInt')),
      );
      expect(
        source.indexOf('getSearchV2SearchLimitDouble'),
        lessThan(source.indexOf('getSearchV2SearchTitle')),
      );
    });

    test('render rejects generated method name collisions', () {
      final manifest = Manifest.fromJson(<String, Object?>{
        'parameters': <String, Object?>{
          'search_v2_search_enabled': <String, Object?>{
            'valueType': 'BOOLEAN',
            'defaultValue': false,
          },
        },
        'parameterGroups': <String, Object?>{
          'Search V2': <String, Object?>{
            'parameters': <String, Object?>{
              'search_enabled': <String, Object?>{
                'valueType': 'BOOLEAN',
                'defaultValue': false,
              },
            },
          },
        },
      });
      final registry = DartModelRegistry.build(manifest.schemaDocument);

      expect(
        () => const RemoteConfigClientRenderer().render(
          manifest,
          DartCodegenSettings.fromYaml(
            loadYaml('dart:\n  output_directory: generated'),
          ),
          DartTypeResolver(manifest.schemaDocument, registry),
        ),
        throwsFormatException,
      );
    });
  });
}
