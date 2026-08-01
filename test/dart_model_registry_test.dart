import 'package:remote_config_codegen/src/dart_model_registry.dart';
import 'package:remote_config_codegen/src/json_schema.dart';
import 'package:test/test.dart';

void main() {
  group('DartModelRegistry', () {
    group('build', () {
      test(
        'registers definitions and nested object models in stable order',
        () {
          final document = JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{
                'cta': <String, Object?>{
                  'type': 'object',
                  'properties': <String, Object?>{},
                },
              },
            },
            'Status': <String, Object?>{
              'type': 'string',
              'enum': <Object?>['active', 'inactive'],
            },
          });

          final registry = DartModelRegistry.build(document);

          expect(
            registry.declarations.map((declaration) => declaration.name),
            <String>['Banner', 'BannerCta', 'Status'],
          );
          expect(registry.nameFor(document.definition('Banner')), 'Banner');
          expect(
            registry.nameForOrNull(document.definition('Status')),
            'Status',
          );
        },
      );
    });

    group('nameFor', () {
      test('rejects an unregistered primitive node', () {
        final registry = DartModelRegistry.build(
          JsonSchemaDocument.fromDefinitions(<String, Object?>{}),
        );
        final primitive = JsonSchemaNode(
          type: JsonSchemaType.string,
          isNullable: false,
        );

        expect(() => registry.nameFor(primitive), throwsFormatException);
      });
    });

    group('nameForOrNull', () {
      test('returns null for an unregistered primitive node', () {
        final registry = DartModelRegistry.build(
          JsonSchemaDocument.fromDefinitions(<String, Object?>{}),
        );
        final primitive = JsonSchemaNode(
          type: JsonSchemaType.string,
          isNullable: false,
        );

        expect(registry.nameForOrNull(primitive), isNull);
      });
    });
  });
}
