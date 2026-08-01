import 'package:remote_config_codegen/src/dart_literal.dart';
import 'package:test/test.dart';

void main() {
  group('DartLiteral', () {
    group('string', () {
      test('escapes single-quoted Dart strings', () {
        expect(DartLiteral.string(r"it's\ready"), r"it\'s\\ready");
      });
    });

    group('value', () {
      test('renders JSON-compatible values as Dart expressions', () {
        expect(DartLiteral.value(null), 'null');
        expect(
          DartLiteral.value(<Object?>[true, 2, 'ok']),
          "<dynamic>[true, 2, 'ok']",
        );
        expect(
          DartLiteral.value(<String, Object?>{'title': 'it\'s'}),
          "<String, dynamic>{'title': 'it\\'s'}",
        );
      });

      test('rejects unsupported values', () {
        expect(() => DartLiteral.value(DateTime(2026)), throwsFormatException);
      });
    });
  });
}
