# Remote Config Codegen Dart example

This Flutter app demonstrates generated `RemoteConfigClient` methods,
parameter group method prefixes, and Freezed JSON models on Android, iOS, and
Web.

The example manifest contains three values:

- `example_param_1`: the number `42`
- `example_param_2`: a JSON object containing a coffee item
- `example_group.example_param_3`: the boolean `true`

## Generate the client and models

From the repository root:

```sh
dart run remote_config_codegen \
  --config example/config.json \
  --settings example/remote_config_codegen.yaml
```

Then, from this directory:

```sh
flutter pub run build_runner build
flutter run
```

## Firebase configuration

The app needs a Firebase project before it can read Remote Config at runtime.
Configure Android, iOS, and Web with the standard FlutterFire setup, then add
the generated Firebase configuration files to this app. Firebase is initialized
before `runApp`, so the platform configuration must be present before launching
the example.

The app sets in-app defaults for all example parameters before fetching Remote
Config, so it has deterministic values once Firebase is initialized.
