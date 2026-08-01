import 'package:remote_config_codegen/remote_config_codegen.dart';
import 'package:test/test.dart';

void main() {
  group('DartSerializer', () {
    test('parse parses every supported YAML value', () {
      for (final serializer in DartSerializer.values) {
        expect(DartSerializer.parse(serializer.yamlValue), serializer);
      }
    });

    test('parse rejects an unsupported YAML value', () {
      expect(
        () => DartSerializer.parse('dart_mappable'),
        throwsFormatException,
      );
    });

    test('parse rejects a non-string YAML value', () {
      expect(() => DartSerializer.parse(true), throwsFormatException);
    });
  });
}
