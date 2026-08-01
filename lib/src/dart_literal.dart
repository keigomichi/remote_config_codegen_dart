/// Renders manifest values as Dart source literals.
///
/// It supports JSON-compatible values used by manifest defaults and escapes
/// strings so the generated source remains valid Dart.
class DartLiteral {
  /// Escapes [value] for inclusion inside a single-quoted Dart string literal.
  static String string(String value) =>
      value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

  /// Converts a JSON-compatible [input] into an equivalent Dart expression.
  static String value(Object? input) => switch (input) {
    null => 'null',
    String stringValue => "'${string(stringValue)}'",
    bool boolValue => '$boolValue',
    num numberValue => '$numberValue',
    List<Object?> listValue => '<dynamic>[${listValue.map(value).join(', ')}]',
    Map<String, Object?> mapValue =>
      "<String, dynamic>{${mapValue.entries.map((entry) => "'${string(entry.key)}': ${value(entry.value)}").join(', ')}}",
    _ => throw FormatException('Cannot render $input as a Dart literal.'),
  };
}
