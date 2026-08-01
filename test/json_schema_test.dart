import 'package:remote_config_codegen/remote_config_codegen.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSchemaDocument', () {
    group('fromDefinitions', () {
      test('parses optional and null-accepting properties as nullable', () {
        final document = JsonSchemaDocument.fromDefinitions(<String, Object?>{
          'Banner': <String, Object?>{
            'type': 'object',
            'required': <Object?>['title'],
            'properties': <String, Object?>{
              'title': <String, Object?>{'type': 'string'},
              'subtitle': <String, Object?>{
                'type': <Object?>['string', 'null'],
              },
              'campaignId': <String, Object?>{'type': 'string'},
            },
          },
        });

        final banner = document.definition('Banner');
        expect(banner.properties['title']!.isNullable, isFalse);
        expect(banner.properties['subtitle']!.isNullable, isTrue);
        expect(banner.requiredProperties.contains('campaignId'), isFalse);
      });

      test('rejects a circular local reference', () {
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Node': <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{
                'child': <String, Object?>{r'$ref': r'#/$defs/Node'},
              },
            },
          }),
          throwsFormatException,
        );
      });

      test('follows a valid local reference', () {
        final document = JsonSchemaDocument.fromDefinitions(<String, Object?>{
          'Banner': <String, Object?>{
            'type': 'object',
            'properties': <String, Object?>{
              'status': <String, Object?>{r'$ref': r'#/$defs/Status'},
            },
          },
          'Status': <String, Object?>{
            'type': 'string',
            'enum': <Object?>['active'],
          },
        });

        expect(
          document.definition('Banner').properties['status']!.referenceName,
          'Status',
        );
      });

      test('rejects invalid definition and node shapes', () {
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': 'not an object',
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{r'$ref': 1},
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': 'array',
              'items': 'not an object',
            },
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': 'object',
              'properties': 'not an object',
            },
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{'title': 'not an object'},
            },
          }),
          throwsFormatException,
        );
      });

      test('rejects invalid types, required fields, and enums', () {
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{'type': 'unsupported'},
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{},
              'required': 'title',
            },
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': <Object?>['string', 'number'],
            },
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': <Object?>['string', 1],
            },
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{
              'type': 'object',
              'properties': <String, Object?>{},
              'required': <Object?>['missing'],
            },
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Status': <String, Object?>{'type': 'string', 'enum': <Object?>[]},
          }),
          throwsFormatException,
        );
      });

      test('rejects unsupported references', () {
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{r'$ref': '#/components/Banner'},
          }),
          throwsFormatException,
        );
        expect(
          () => JsonSchemaDocument.fromDefinitions(<String, Object?>{
            'Banner': <String, Object?>{r'$ref': r'#/$defs/Missing'},
          }),
          throwsFormatException,
        );
      });
    });

    group('definition', () {
      test('rejects an undefined name', () {
        final document = JsonSchemaDocument.fromDefinitions(
          <String, Object?>{},
        );

        expect(() => document.definition('Missing'), throwsFormatException);
      });
    });
  });
}
