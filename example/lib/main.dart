import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'generated/remote_config/remote_config_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults(const <String, Object>{
    'example_param_1': 42,
    'example_param_2':
        '{"items":[{"name":"coffee",'
        '"background_color":"#6750A4"}]}',
    'example_param_3': true,
  });
  await remoteConfig.fetchAndActivate();

  // Create a RemoteConfigClient instance with the FirebaseRemoteConfig instance
  final remoteConfigClient = RemoteConfigClient(remoteConfig);

  runApp(RemoteConfigCodegenExampleApp(client: remoteConfigClient));
}

class RemoteConfigCodegenExampleApp extends StatelessWidget {
  const RemoteConfigCodegenExampleApp({required this.client, super.key});

  final RemoteConfigClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Config Codegen Dart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RemoteConfigExamplePage(client: client),
    );
  }
}

class RemoteConfigExamplePage extends StatelessWidget {
  const RemoteConfigExamplePage({required this.client, super.key});

  final RemoteConfigClient client;

  @override
  Widget build(BuildContext context) {
    final exampleParam2 = client.getExampleParam2();

    return Scaffold(
      appBar: AppBar(title: const Text('Remote Config Codegen Example')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Generated RemoteConfigClient',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('example_param_1'),
            subtitle: Text(
              'int: ${client.getExampleParam1Int()} / '
              'double: ${client.getExampleParam1Double()}',
            ),
          ),
          ListTile(
            title: const Text('example_param_3 (example_group)'),
            subtitle: Text('${client.getExampleGroupExampleParam3()}'),
          ),
          const SizedBox(height: 16),
          Text(
            'Generated JSON model',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final item in exampleParam2.items)
            Card(
              color:
                  _colorFromHex(item.backgroundColor) ??
                  Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(item.name),
              ),
            ),
        ],
      ),
    );
  }

  Color? _colorFromHex(String? value) {
    if (value == null || !RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
      return null;
    }
    return Color(int.parse(value.substring(1), radix: 16) | 0xFF000000);
  }
}
