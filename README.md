# Remote Config Codegen

[![pub version](https://img.shields.io/pub/v/remote_config_codegen.svg)](https://pub.dev/packages/remote_config_codegen)
[![CI](https://github.com/keigomichi/remote_config_codegen_dart/actions/workflows/ci.yaml/badge.svg)](https://github.com/keigomichi/remote_config_codegen_dart/actions/workflows/ci.yaml)

`remote_config_codegen` is a Dart CLI that generates a type-safe Firebase
Remote Config access API and Dart JSON models from a JSON Manifest.
It lets Flutter applications read Firebase Remote Config values through typed
methods instead of string keys, Firebase getter selection, and manual JSON
parsing.

## What it generates

Define Firebase Remote Config parameters and JSON value shapes once in a JSON
Manifest:

```json
{
  "parameters": {
    "app_new_purchase_flow": {
      "valueType": "BOOLEAN",
      "defaultValue": false
    },
    "app_home_banner_config": {
      "valueType": "JSON",
      "defaultValue": { "banners": [] },
      "valueSchema": { "$ref": "#/$defs/HomeBannerConfig" }
    }
  },
  "$defs": {
    "HomeBannerConfig": {
      "type": "object",
      "required": ["banners"],
      "properties": {
        "banners": { "type": "array", "items": { "type": "string" } }
      }
    }
  }
}
```

The CLI then generates a Firebase-backed, typed API. With the default
`json_serializable` serializer, the relevant output is equivalent to:

```dart
// remote_config_models.dart
@JsonSerializable()
class HomeBannerConfig {
  const HomeBannerConfig({required this.banners});

  factory HomeBannerConfig.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerConfigFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerConfigToJson(this);

  final List<String> banners;
}

// remote_config_client.dart
class RemoteConfigClient {
  const RemoteConfigClient(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  bool getAppNewPurchaseFlow() =>
      _remoteConfig.getBool('app_new_purchase_flow');

  HomeBannerConfig getAppHomeBannerConfig() {
    try {
      final decoded = jsonDecode(
        _remoteConfig.getString('app_home_banner_config'),
      );
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object.');
      }
      return HomeBannerConfig.fromJson(decoded);
    } on Object {
      return HomeBannerConfig.fromJson(
        <String, dynamic>{'banners': <dynamic>[]},
      );
    }
  }
}
```

Application code calls typed methods instead of using string keys, Firebase
getter selection, or JSON parsing directly:

```dart
final client = RemoteConfigClient(FirebaseRemoteConfig.instance);
final bool enabled = client.getAppNewPurchaseFlow();
final HomeBannerConfig banners = client.getAppHomeBannerConfig();
```

## Usage

Place `remote_config_codegen.yaml` at the root of your Flutter project and run
the CLI with the Manifest path.

```sh
dart run remote_config_codegen \
  --config config.json
```

Unless `--settings` is specified, the CLI reads
`remote_config_codegen.yaml` from the current working directory.

## Generation settings

```yaml
# remote_config_codegen.yaml
dart:
  output_directory: lib/src/generated/remote_config
  serializer: json_serializable
  remote_config_client_class_name: RemoteConfigClient
```

`serializer` supports `json_serializable` and `freezed`, and defaults to
`json_serializable` when omitted. If `remote_config_client_class_name` is
omitted, it defaults to `RemoteConfigClient`.

The generated code is Firebase-specific in the first release. The generated
`RemoteConfigClient` receives `FirebaseRemoteConfig` directly through its
constructor, so the consuming application needs `firebase_remote_config`.

Generated JSON models require these pinned packages in the consuming
application:

```yaml
dependencies:
  json_annotation: 4.12.0

dev_dependencies:
  build_runner: 2.15.1
  json_serializable: 6.14.0
```

To generate Freezed models, set `serializer: freezed` and use these pinned
packages instead:

```yaml
dependencies:
  freezed_annotation: 3.1.0
  json_annotation: 4.12.0

dev_dependencies:
  build_runner: 2.15.1
  freezed: 3.2.5
  json_serializable: 6.14.0
```

After running this CLI, generate the `*.g.dart` files from the consuming
project:

```sh
dart run build_runner build
```

For the initial JSON Schema subset, properties that are not defined by the
Schema are ignored by generated models. Remote Config value types are aligned
with Firebase: `STRING`, `BOOLEAN`, `NUMBER`, and `JSON`. Within a JSON value
schema, both optional properties and nullable properties are generated as
nullable Dart fields (`T?`).

Every `NUMBER` parameter generates two methods:
`get<Parameter>Int()` and `get<Parameter>Double()`. If a `JSON` parameter
cannot be parsed or converted into its model, the generated client falls back
to the Manifest's `defaultValue`.

Every generated Dart file starts with
`// GENERATED CODE - DO NOT MODIFY BY HAND`. Change the Manifest or JSON
Schema and run the generator again instead of editing generated files.

## Manifest example

```json
{
  "$schema": "./schema/remote_config_manifest.schema.json",
  "parameters": {
    "app_new_purchase_flow": {
      "valueType": "BOOLEAN",
      "defaultValue": false
    },
    "app_home_banner_config": {
      "valueType": "JSON",
      "defaultValue": { "banners": [] },
      "valueSchema": { "$ref": "#/$defs/HomeBannerConfig" }
    }
  },
  "$defs": {
    "HomeBannerConfig": {
      "type": "object",
      "required": ["banners"],
      "properties": {
        "banners": { "type": "array", "items": { "type": "string" } }
      }
    }
  }
}
```

The package provides the Meta Schema at
[`schema/remote_config_manifest.schema.json`](schema/remote_config_manifest.schema.json).
Consumer projects can refer to a copy of this file through `$schema`. A
versioned URL will be provided when the package is published.
