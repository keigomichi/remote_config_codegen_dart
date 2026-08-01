import 'dart:io';

import 'package:args/args.dart';

import 'dart_codegen_settings.dart';
import 'dart_source_generator.dart';
import 'generated_file_writer.dart';
import 'manifest.dart';

/// Runs the code generator from command-line arguments.
///
/// The CLI validates the manifest and settings before writing and formatting
/// the generated Dart sources. It returns a process-compatible exit code so
/// callers can use it from the executable or from another Dart entry point.
class RemoteConfigCodegenCli {
  final _parser = ArgParser(allowTrailingOptions: false)
    ..addOption(
      'config',
      help: 'Path to the Remote Config manifest JSON file.',
      valueHelp: 'path',
    )
    ..addOption(
      'settings',
      defaultsTo: 'remote_config_codegen.yaml',
      help: 'Path to the generator settings YAML file.',
      valueHelp: 'path',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    );

  /// Generates sources from [arguments] and returns a process exit code.
  ///
  /// [arguments] accepts `--config` for the required JSON manifest and an
  /// optional `--settings` YAML path. A usage error returns `64`, an input or
  /// output file error returns `66`, and invalid configuration returns `65`.
  Future<int> run(List<String> arguments) async {
    late ArgResults results;
    try {
      results = _parser.parse(arguments);
    } on ArgParserException catch (error) {
      stderr.writeln(error.message);
      return 64;
    }

    if (results.flag('help')) {
      _writeUsage();
      return 0;
    }

    if (results.rest.isNotEmpty) {
      stderr.writeln(
        'Unexpected positional arguments: ${results.rest.join(' ')}',
      );
      return 64;
    }

    final configPath = results.option('config');
    final settingsPath =
        results.option('settings') ?? 'remote_config_codegen.yaml';

    if (configPath == null) {
      stderr.writeln('Missing required --config <path>.');
      return 64;
    }

    try {
      final manifest = await Manifest.read(File(configPath));

      final settingsFile = File(settingsPath);
      final settings = await DartCodegenSettings.read(settingsFile);

      final generatedSources = const DartSourceGenerator().generate(
        manifest,
        settings,
      );
      final generatedFiles = await GeneratedFileWriter().writeAll(
        outputDirectory: settings.resolveOutputDirectory(settingsFile.parent),
        files: <String, String>{
          'remote_config_models.dart': generatedSources.models,
          'remote_config_client.dart': generatedSources.client,
        },
      );

      final result = await Process.run(Platform.resolvedExecutable, <String>[
        'format',
        ...generatedFiles.map((File file) => file.path),
      ]);
      if (result.exitCode != 0) {
        throw FileSystemException('dart format failed: ${result.stderr}');
      }
    } on FileSystemException catch (error) {
      stderr.writeln(error.message);
      return 66;
    } on FormatException catch (error) {
      stderr.writeln('Invalid configuration: ${error.message}');
      return 65;
    }

    stdout.writeln('Remote Config Dart sources were generated.');
    return 0;
  }

  void _writeUsage() {
    stderr.writeln('Usage: remote_config_codegen --config <path> [options]');
    stderr.writeln(_parser.usage);
  }
}
