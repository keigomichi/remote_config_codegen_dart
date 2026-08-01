import 'package:remote_config_codegen/src/dart_model_registry.dart';
import 'package:remote_config_codegen/src/dart_type_resolver.dart';
import 'package:remote_config_codegen/src/json_schema.dart';
import 'package:test/test.dart';

void main() {
  group('DartTypeResolver', () {
    test(
      'typeFor resolves primitives, arrays, references, and nullable types',
      () {
        final document = JsonSchemaDocument.fromDefinitions(<String, Object?>{
          'Banner': <String, Object?>{
            'type': 'object',
            'properties': <String, Object?>{},
          },
          'MaxItems': <String, Object?>{'type': 'integer'},
        });
        final resolver = DartTypeResolver(
          document,
          DartModelRegistry.build(document),
        );

        expect(
          resolver.typeFor(
            JsonSchemaNode(type: JsonSchemaType.integer, isNullable: true),
          ),
          'int?',
        );
        expect(
          resolver.typeFor(
            JsonSchemaNode(
              type: JsonSchemaType.array,
              isNullable: false,
              items: JsonSchemaNode(
                type: JsonSchemaType.boolean,
                isNullable: false,
              ),
            ),
          ),
          'List<bool>',
        );
        expect(
          resolver.typeFor(
            JsonSchemaNode(
              type: JsonSchemaType.reference,
              isNullable: false,
              referenceName: 'Banner',
            ),
          ),
          'Banner',
        );
        expect(
          resolver.typeFor(
            JsonSchemaNode(
              type: JsonSchemaType.reference,
              isNullable: false,
              referenceName: 'MaxItems',
            ),
          ),
          'int',
        );
      },
    );
  });
}
