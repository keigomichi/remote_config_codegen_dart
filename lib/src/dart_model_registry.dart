import 'package:meta/meta.dart';

import 'dart_names.dart';
import 'json_schema.dart';

/// Collects the Dart model declarations derived from a schema document.
///
/// The registry assigns stable Dart type names to object and enum nodes before
/// renderers run. This keeps model discovery and language rendering separate.
class DartModelRegistry {
  DartModelRegistry._()
    : _names = <JsonSchemaNode, String>{},
      declarations = <DartModelDeclaration>[];

  /// Builds a registry for all object and enum types reachable from [document].
  ///
  /// Local definitions are processed in name order so generated source remains
  /// stable regardless of map insertion order in the original manifest.
  factory DartModelRegistry.build(JsonSchemaDocument document) {
    final registry = DartModelRegistry._();

    final definitionNames = document.definitions.keys.toList()..sort();
    for (final name in definitionNames) {
      final definition = document.definition(name);
      if (definition.type == JsonSchemaType.object ||
          definition.enumValues.isNotEmpty) {
        registry._register(definition, DartNames.type(name));
      }
    }
    return registry;
  }

  final Map<JsonSchemaNode, String> _names;

  /// Declarations in deterministic generation order.
  final List<DartModelDeclaration> declarations;

  /// Returns the generated Dart name assigned to [node].
  ///
  /// Throws [FormatException] if the node does not correspond to a generated
  /// model declaration.
  String nameFor(JsonSchemaNode node) {
    final name = nameForOrNull(node);
    if (name == null) {
      throw const FormatException(
        'No Dart model name was assigned to this JSON Schema node.',
      );
    }
    return name;
  }

  /// Returns the generated Dart name for [node], if it has one.
  ///
  /// Primitive nodes without an enum model have no registered name.
  String? nameForOrNull(JsonSchemaNode node) => _names[node];

  void _register(JsonSchemaNode node, String name) {
    if (_names.containsKey(node)) {
      return;
    }
    _names[node] = name;

    declarations.add(DartModelDeclaration(name: name, node: node));

    if (node.type == JsonSchemaType.object) {
      for (final property in node.properties.entries) {
        _visit(property.value, name + DartNames.type(property.key));
      }
    }
  }

  void _visit(JsonSchemaNode node, String candidateName) {
    if (node.type == JsonSchemaType.reference) {
      return;
    }
    if (node.type == JsonSchemaType.array) {
      _visit(node.items!, '${candidateName}Item');
      return;
    }
    if (node.type == JsonSchemaType.object || node.enumValues.isNotEmpty) {
      _register(node, candidateName);
    }
  }
}

/// Pairs a generated Dart type name with its source JSON Schema node.
///
/// Renderers use this lightweight value to emit the model body for [node].
@immutable
class DartModelDeclaration {
  /// Creates a declaration for a named generated Dart model.
  const DartModelDeclaration({required this.name, required this.node});

  /// The generated PascalCase Dart type name.
  final String name;

  /// The parsed schema node that defines the model's members.
  final JsonSchemaNode node;
}
