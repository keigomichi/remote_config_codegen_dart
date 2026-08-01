import 'package:remote_config_codegen/remote_config_codegen_dart.dart';
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
  });
}
