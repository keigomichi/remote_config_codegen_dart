/// Converts manifest names into Dart identifiers used by generated source.
///
/// The conversion accepts alphanumeric words separated by punctuation. Invalid
/// or digit-leading names fail early with [FormatException].
class DartNames {
  /// Validates that [input] can be converted into a Dart identifier.
  ///
  /// Throws [FormatException] when [input] has no usable words or starts with
  /// a digit.
  static void validate(String input) {
    _words(input);
  }

  /// Converts [input] into a PascalCase Dart type identifier.
  static String type(String input) => _words(input).map(_capitalize).join();

  /// Converts [input] into a lowerCamelCase Dart field identifier.
  static String field(String input) {
    final words = _words(input);
    if (words.isEmpty) {
      throw FormatException('Cannot create a Dart name from $input.');
    }
    return words.first.toLowerCase() + words.skip(1).map(_capitalize).join();
  }

  static List<String> _words(String input) {
    final words = input
        .split(RegExp(r'[^A-Za-z0-9]+'))
        .where((String word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty || RegExp(r'^\d').hasMatch(words.first)) {
      throw FormatException('Cannot create a Dart identifier from $input.');
    }
    return words;
  }

  static String _capitalize(String value) =>
      value[0].toUpperCase() + value.substring(1);
}
