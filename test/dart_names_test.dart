import 'package:remote_config_codegen/src/dart_names.dart';
import 'package:test/test.dart';

void main() {
  group('DartNames', () {
    group('type', () {
      test('converts separator-delimited input to a type identifier', () {
        expect(DartNames.type('app_home-banner'), 'AppHomeBanner');
      });

      test('rejects digit-leading identifiers', () {
        expect(() => DartNames.type('123-banner'), throwsFormatException);
      });
    });

    group('field', () {
      test('converts separator-delimited input to a field identifier', () {
        expect(DartNames.field('app_home-banner'), 'appHomeBanner');
      });

      test('rejects an input without identifier characters', () {
        expect(() => DartNames.field('---'), throwsFormatException);
      });
    });
  });
}
