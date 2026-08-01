import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'generated/remote_config/remote_config_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults(const <String, Object>{
    'app_new_purchase_flow': false,
    'app_max_items': 3,
    'app_home_banner_config':
        '{"banners":[{"title":"Generated from a JSON Schema",'
        '"background_color":"#6750A4"}]}',
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
    final bannerConfig = client.getAppHomeBannerConfig();

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
            title: const Text('app_new_purchase_flow'),
            subtitle: Text('${client.getAppNewPurchaseFlow()}'),
          ),
          ListTile(
            title: const Text('app_max_items'),
            subtitle: Text(
              'int: ${client.getAppMaxItemsInt()} / '
              'double: ${client.getAppMaxItemsDouble()}',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Generated JSON model',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final banner in bannerConfig.banners)
            Card(
              color:
                  _colorFromHex(banner.backgroundColor) ??
                  Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(banner.title),
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
