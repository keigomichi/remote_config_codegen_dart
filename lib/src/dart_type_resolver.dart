import 'package:meta/meta.dart';

import 'dart_model_registry.dart';
import 'json_schema.dart';

/// Resolves parsed schema nodes to their corresponding Dart type strings.
///
/// Registered object and enum nodes resolve to generated model names; primitive
/// nodes resolve to built-in Dart types, recursively handling arrays and refs.
@immutable
class DartTypeResolver {
  /// Creates a resolver using a parsed [document] and generated [registry].
  const DartTypeResolver(this.document, this.registry);

  /// The document used to follow local references.
  final JsonSchemaDocument document;

  /// The generated model names used for object and enum nodes.
  final DartModelRegistry registry;

  /// Returns the Dart type string corresponding to [node].
  ///
  /// Nullable JSON Schema types receive a `?` suffix; array item types are
  /// resolved recursively.
  String typeFor(JsonSchemaNode node) {
    final type = switch (node.type) {
      JsonSchemaType.reference => _typeForReference(node.referenceName!),
      JsonSchemaType.string => _registeredOr('String', node),
      JsonSchemaType.number => _registeredOr('double', node),
      JsonSchemaType.integer => _registeredOr('int', node),
      JsonSchemaType.boolean => _registeredOr('bool', node),
      JsonSchemaType.array => 'List<${typeFor(node.items!)}>',
      JsonSchemaType.object => registry.nameFor(node),
    };
    return node.isNullable ? '$type?' : type;
  }

  String _typeForReference(String referenceName) {
    final target = document.definition(referenceName);
    final registeredName = registry.nameForOrNull(target);
    return registeredName ?? typeFor(target);
  }

  String _registeredOr(String fallback, JsonSchemaNode node) =>
      registry.nameForOrNull(node) ?? fallback;
}
