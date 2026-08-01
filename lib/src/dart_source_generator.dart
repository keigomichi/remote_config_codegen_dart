import 'package:meta/meta.dart';

import 'dart_codegen_settings.dart';
import 'dart_model_registry.dart';
import 'dart_model_renderer.dart';
import 'dart_type_resolver.dart';
import 'manifest.dart';
import 'remote_config_client_renderer.dart';

/// Coordinates generation of a typed Remote Config client and JSON models.
///
/// The generator reads a validated [Manifest] and delegates model rendering to
/// the serializer chosen in [DartCodegenSettings]. Model and client rendering
/// are delegated to dedicated renderers; file writes remain the CLI's concern.
class DartSourceGenerator {
  /// Creates a stateless generator that can be reused across invocations.
  const DartSourceGenerator();

  /// Produces all Dart sources required for [manifest].
  ///
  /// The returned [GeneratedDartSources] separates model code from client code
  /// so callers can write each file independently to their output directory.
  GeneratedDartSources generate(
    Manifest manifest,
    DartCodegenSettings settings,
  ) {
    final registry = DartModelRegistry.build(manifest.schemaDocument);
    final resolver = DartTypeResolver(manifest.schemaDocument, registry);

    final models = DartModelRenderer.forSerializer(
      settings.serializer,
    ).render(registry, resolver);
    final remoteConfigClient = RemoteConfigClientRenderer().render(
      manifest,
      settings,
      resolver,
    );

    return GeneratedDartSources(models: models, client: remoteConfigClient);
  }
}

/// Contains the generated source text for one invocation.
///
/// [models] and [client] are deliberately separate because they have different
/// imports, part-file requirements, and output file names.
@immutable
class GeneratedDartSources {
  /// Creates the generated model and client source pair.
  const GeneratedDartSources({required this.models, required this.client});

  /// Source for `remote_config_models.dart`.
  ///
  /// It contains JSON models rendered for the selected serializer.
  final String models;

  /// Source for `remote_config_client.dart`.
  ///
  /// It exposes typed accessors over a `FirebaseRemoteConfig` instance.
  final String client;
}
