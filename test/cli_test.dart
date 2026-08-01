import 'dart:io';

import 'package:remote_config_codegen/remote_config_codegen.dart';
import 'package:test/test.dart';

void main() {
  group('RemoteConfigCodegenCli', () {
    test('run returns a usage error when --config is omitted', () async {
      expect(await RemoteConfigCodegenCli().run(<String>[]), 64);
    });

    test(
      'run returns a usage error for unknown or positional arguments',
      () async {
        final cli = RemoteConfigCodegenCli();

        expect(await cli.run(<String>['--unknown']), 64);
        expect(await cli.run(<String>['unexpected']), 64);
      },
    );

    test('run accepts the help option without a configuration file', () async {
      expect(await RemoteConfigCodegenCli().run(<String>['--help']), 0);
    });

    test(
      'run returns an invalid configuration error for an invalid manifest',
      () async {
        final directory = await Directory.systemTemp.createTemp(
          'rcc-cli-test-',
        );
        addTearDown(() => directory.delete(recursive: true));
        final config = File('${directory.path}/config.json');
        final settings = File('${directory.path}/remote_config_codegen.yaml');
        await config.writeAsString('''
{
  "parameters": {
    "app_enabled": { "valueType": "BOOLEAN", "defaultValue": "false" }
  }
}
''');
        await settings.writeAsString('''
dart:
  output_directory: generated
''');

        expect(
          await RemoteConfigCodegenCli().run(<String>[
            '--config=${config.path}',
            '--settings=${settings.path}',
          ]),
          65,
        );
      },
    );

    test('run generates files when valid paths are supplied', () async {
      final directory = await Directory.systemTemp.createTemp('rcc-cli-test-');
      addTearDown(() => directory.delete(recursive: true));
      final config = File('${directory.path}/config.json');
      final settings = File('${directory.path}/remote_config_codegen.yaml');
      await config.writeAsString('''
{
  "parameters": {
    "app_enabled": { "valueType": "BOOLEAN", "defaultValue": false }
  }
}
''');
      await settings.writeAsString('''
dart:
  output_directory: generated
''');

      final exitCode = await RemoteConfigCodegenCli().run(<String>[
        '--config=${config.path}',
        '--settings=${settings.path}',
      ]);

      expect(exitCode, 0);
      expect(
        await File(
          '${directory.path}/generated/remote_config_client.dart',
        ).exists(),
        isTrue,
      );
      expect(
        await File(
          '${directory.path}/generated/remote_config_models.dart',
        ).exists(),
        isTrue,
      );
    });
  });
}
