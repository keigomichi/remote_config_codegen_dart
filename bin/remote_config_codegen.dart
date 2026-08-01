import 'dart:io';

import 'package:remote_config_codegen/remote_config_codegen_dart.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await RemoteConfigCodegenCli().run(arguments);
}
