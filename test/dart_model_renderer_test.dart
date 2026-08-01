import 'dart:io';

import 'package:remote_config_codegen/src/dart_model_renderer.dart';
import 'package:remote_config_codegen/src/dart_model_registry.dart';
import 'package:remote_config_codegen/src/dart_type_resolver.dart';
import 'package:remote_config_codegen/remote_config_codegen_dart.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('DartModelRenderer', () {
    group('forSerializer', () {
      test('selects a renderer for each supported serializer', () {
        expect(
          DartModelRenderer.forSerializer(DartSerializer.jsonSerializable),
          isA<JsonSerializableModelRenderer>(),
        );
        expect(
          DartModelRenderer.forSerializer(DartSerializer.freezed),
          isA<FreezedModelRenderer>(),
        );
      });
    });

    group('renderEnum', () {
      test('emits JSON value annotations for renamed members', () {
        const renderer = _TestModelRenderer();
        final source = renderer.renderEnumForTest(
          JsonSchemaNode(
            type: JsonSchemaType.string,
            isNullable: false,
            enumValues: <Object?>['in-progress'],
          ),
        );

        expect(source, contains("@JsonValue('in-progress')"));
        expect(source, contains('inProgress,'));
      });

      test('rejects non-string enum members', () {
        const renderer = _TestModelRenderer();

        expect(
          () => renderer.renderEnumForTest(
            JsonSchemaNode(
              type: JsonSchemaType.number,
              isNullable: false,
              enumValues: <Object?>[1],
            ),
          ),
          throwsFormatException,
        );
      });
    });

    group('render', () {
      test('adds JSON key annotations and enum declarations', () {
        final document = JsonSchemaDocument.fromDefinitions(<String, Object?>{
          'Banner': <String, Object?>{
            'type': 'object',
            'properties': <String, Object?>{
              'display-title': <String, Object?>{'type': 'string'},
            },
          },
          'Status': <String, Object?>{
            'type': 'string',
            'enum': <Object?>['in-progress'],
          },
        });
        final registry = DartModelRegistry.build(document);
        final source = const JsonSerializableModelRenderer().render(
          registry,
          DartTypeResolver(document, registry),
        );

        expect(source, contains("@JsonKey(name: 'display-title')"));
        expect(source, contains('enum Status'));

        final freezedSource = const FreezedModelRenderer().render(
          registry,
          DartTypeResolver(document, registry),
        );
        expect(freezedSource, contains("@JsonKey(name: 'display-title')"));
        expect(freezedSource, contains('enum Status'));
      });
    });
  });

  for (final serializer in DartSerializer.values) {
    group(
      serializer == DartSerializer.jsonSerializable
          ? 'JsonSerializableModelRenderer'
          : 'FreezedModelRenderer',
      () {
        test('render matches its golden file', () {
          final sources = const DartSourceGenerator().generate(
            _manifest(),
            DartCodegenSettings.fromYaml(
              loadYaml('''
dart:
  output_directory: lib/generated
  serializer: ${serializer.yamlValue}
'''),
            ),
          );
          final expected = File(
            'test/golden/${serializer.yamlValue}_models.dart',
          ).readAsStringSync();

          expect(sources.models.trimRight(), expected.trimRight());
        });
      },
    );
  }
}

Manifest _manifest() => Manifest.fromJson(<String, Object?>{
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

class _TestModelRenderer extends DartModelRenderer {
  const _TestModelRenderer();

  @override
  String render(DartModelRegistry registry, DartTypeResolver resolver) => '';

  String renderEnumForTest(JsonSchemaNode node) {
    final buffer = StringBuffer();
    renderEnum(buffer, 'Status', node);
    return buffer.toString();
  }
}
