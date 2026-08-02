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
    "example_param_1": {
      "valueType": "NUMBER",
      "defaultValue": 42
    },
    "example_param_2": {
      "valueType": "JSON",
      "defaultValue": {
        "items": [
          { "name": "coffee", "background_color": "#6750A4" }
        ]
      },
      "valueSchema": { "$ref": "#/$defs/MenuConfig" }
    }
  },
  "parameterGroups": {
    "example_group": {
      "parameters": {
        "example_param_3": {
          "valueType": "BOOLEAN",
          "defaultValue": true
        }
      }
    }
  },
  "$defs": {
    "MenuConfig": {
      "type": "object",
      "required": ["items"],
      "properties": {
        "items": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["name"],
            "properties": {
              "name": { "type": "string" },
              "background_color": { "type": "string" }
            }
          }
        }
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
class MenuConfig {
  const MenuConfig({required this.items});

  factory MenuConfig.fromJson(Map<String, dynamic> json) =>
      _$MenuConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MenuConfigToJson(this);

  final List<MenuConfigItemsItem> items;
}

@JsonSerializable()
class MenuConfigItemsItem {
  const MenuConfigItemsItem({required this.name, this.backgroundColor});

  factory MenuConfigItemsItem.fromJson(Map<String, dynamic> json) =>
      _$MenuConfigItemsItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuConfigItemsItemToJson(this);

  final String name;

  @JsonKey(name: 'background_color')
  final String? backgroundColor;
}

// remote_config_client.dart
class RemoteConfigClient {
  const RemoteConfigClient(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  int getExampleParam1Int() => _remoteConfig.getInt('example_param_1');

  double getExampleParam1Double() =>
      _remoteConfig.getDouble('example_param_1');

  MenuConfig getExampleParam2() {
    try {
      final decoded = jsonDecode(
        _remoteConfig.getString('example_param_2'),
      );
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object.');
      }
      return MenuConfig.fromJson(decoded);
    } on Object {
      return MenuConfig.fromJson(
        <String, dynamic>{
          'items': <dynamic>[
            <String, dynamic>{
              'name': 'coffee',
              'background_color': '#6750A4',
            },
          ],
        },
      );
    }
  }

  bool getExampleGroupExampleParam3() =>
      _remoteConfig.getBool('example_param_3');
}
```

Application code calls typed methods instead of using string keys, Firebase
getter selection, or JSON parsing directly:

```dart
final client = RemoteConfigClient(FirebaseRemoteConfig.instance);
final int param1 = client.getExampleParam1Int();
final MenuConfig param2 = client.getExampleParam2();
final bool param3 = client.getExampleGroupExampleParam3();
```

Parameters under `parameterGroups` remain in the same generated client. Their
method names use `get<GroupName><ParameterName>`, while Firebase lookups still
use the original parameter key. Top-level parameters keep their existing
`get<ParameterName>` methods. A manifest may contain either form or both.

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

Every top-level `NUMBER` parameter generates `get<Parameter>Int()` and
`get<Parameter>Double()`; grouped numbers include the group prefix in both
names. If a `JSON` parameter cannot be parsed or converted into its model, the
generated client falls back to the Manifest's `defaultValue`.

Every generated Dart file starts with
`// GENERATED CODE - DO NOT MODIFY BY HAND`. Change the Manifest or JSON
Schema and run the generator again instead of editing generated files.

## Manifest example

```json
{
  "$schema": "./schema/remote_config_manifest.schema.json",
  "parameters": {
    "example_param_1": {
      "valueType": "NUMBER",
      "defaultValue": 42
    },
    "example_param_2": {
      "valueType": "JSON",
      "defaultValue": {
        "items": [
          { "name": "coffee", "background_color": "#6750A4" }
        ]
      },
      "valueSchema": { "$ref": "#/$defs/MenuConfig" }
    }
  },
  "parameterGroups": {
    "example_group": {
      "parameters": {
        "example_param_3": {
          "valueType": "BOOLEAN",
          "defaultValue": true
        }
      }
    }
  },
  "$defs": {
    "MenuConfig": {
      "type": "object",
      "required": ["items"],
      "properties": {
        "items": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["name"],
            "properties": {
              "name": { "type": "string" },
              "background_color": { "type": "string" }
            }
          }
        }
      }
    }
  }
}
```

The package provides the Meta Schema at
[`schema/remote_config_manifest.schema.json`](schema/remote_config_manifest.schema.json).
Consumer projects can refer to a copy of this file through `$schema`. A
versioned URL will be provided when the package is published.
