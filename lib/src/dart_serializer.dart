/// Lists the annotation-based serializers supported by generated models.
///
/// Each value has a stable [yamlValue] used in `remote_config_codegen.yaml`.
/// The renderer selection is intentionally limited to these values so every
/// configuration produces a known, testable model shape.
enum DartSerializer {
  jsonSerializable('json_serializable'),
  freezed('freezed');

  const DartSerializer(this.yamlValue);

  /// The string representation accepted by the YAML settings file.
  ///
  /// This is kept separate from the enum name so the configuration format can
  /// remain stable even if Dart naming needs to change in the future.
  final String yamlValue;

  /// Converts a YAML serializer value into its matching enum member.
  ///
  /// Only the documented [yamlValue] strings are accepted. Any other value,
  /// including non-strings, throws [FormatException] with configuration
  /// guidance suitable for CLI output.
  static DartSerializer parse(Object? value) =>
      DartSerializer.values.firstWhere(
        (serializer) => serializer.yamlValue == value,
        orElse: () => throw const FormatException(
          'dart.serializer must be json_serializable or freezed.',
        ),
      );
}
