import 'package:remote_config_codegen/remote_config_codegen.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('DartSourceGenerator', () {
    test('generate renders json_serializable models and a Firebase client', () {
      final manifest = Manifest.fromJson(<String, Object?>{
        'parameters': <String, Object?>{
          'app_enabled': <String, Object?>{
            'valueType': 'BOOLEAN',
            'defaultValue': false,
          },
          'app_max_items': <String, Object?>{
            'valueType': 'NUMBER',
            'defaultValue': 12,
          },
          'app_banner': <String, Object?>{
            'valueType': 'JSON',
            'defaultValue': <String, Object?>{'banners': <Object?>[]},
            'valueSchema': <String, Object?>{
              r'$ref': r'#/$defs/HomeBannerConfig',
            },
          },
        },
        r'$defs': <String, Object?>{
          'HomeBannerConfig': <String, Object?>{
            'type': 'object',
            'required': <Object?>['banners'],
            'properties': <String, Object?>{
              'banners': <String, Object?>{
                'type': 'array',
                'items': <String, Object?>{'type': 'string'},
              },
              'subtitle': <String, Object?>{
                'type': <Object?>['string', 'null'],
              },
              'cta': <String, Object?>{
                'type': 'object',
                'properties': <String, Object?>{
                  'label': <String, Object?>{'type': 'string'},
                },
              },
            },
          },
        },
      });
      final settings = DartCodegenSettings.fromYaml(
        loadYaml('''
dart:
  output_directory: lib/generated
  serializer: json_serializable
'''),
      );

      final sources = const DartSourceGenerator().generate(manifest, settings);

      expect(
        sources.models,
        startsWith('// GENERATED CODE - DO NOT MODIFY BY HAND'),
      );
      expect(
        sources.client,
        startsWith('// GENERATED CODE - DO NOT MODIFY BY HAND'),
      );
      expect(sources.models, contains('class HomeBannerConfig'));
      expect(sources.models, contains('class HomeBannerConfigCta'));
      expect(sources.models, contains('final HomeBannerConfigCta? cta;'));
      expect(sources.models, contains('final String? subtitle;'));
      expect(
        sources.client,
        contains('final FirebaseRemoteConfig _remoteConfig;'),
      );
      expect(sources.client, isNot(contains('static const String')));
      expect(sources.client, contains("_remoteConfig.getBool('app_enabled')"));
      expect(sources.client, contains("_remoteConfig.getString('app_banner')"));
      expect(sources.client, contains('bool getAppEnabled()'));
      expect(sources.client, contains('int getAppMaxItemsInt()'));
      expect(sources.client, contains('double getAppMaxItemsDouble()'));
      expect(sources.client, contains('HomeBannerConfig getAppBanner()'));
      expect(sources.client, contains("'banners': <dynamic>[]"));
    });

    test('generate renders Freezed models when selected', () {
      final manifest = Manifest.fromJson(<String, Object?>{
        'parameters': <String, Object?>{
          'app_banner': <String, Object?>{
            'valueType': 'JSON',
            'defaultValue': <String, Object?>{'title': 'Default'},
            'valueSchema': <String, Object?>{r'$ref': r'#/$defs/Banner'},
          },
        },
        r'$defs': <String, Object?>{
          'Banner': <String, Object?>{
            'type': 'object',
            'required': <Object?>['title'],
            'properties': <String, Object?>{
              'title': <String, Object?>{'type': 'string'},
              'subtitle': <String, Object?>{'type': 'string'},
            },
          },
        },
      });
      final settings = DartCodegenSettings.fromYaml(
        loadYaml('''
dart:
  output_directory: lib/generated
  serializer: freezed
'''),
      );

      final sources = const DartSourceGenerator().generate(manifest, settings);

      expect(
        sources.models,
        contains(
          "import 'package:freezed_annotation/freezed_annotation.dart';",
        ),
      );
      expect(
        sources.models,
        contains("part 'remote_config_models.freezed.dart';"),
      );
      expect(
        sources.models,
        contains('abstract class Banner with _\$Banner {'),
      );
      expect(
        sources.models,
        contains(
          'const factory Banner({required String title, String? subtitle})',
        ),
      );
    });
  });
}
