// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuConfig _$MenuConfigFromJson(Map<String, dynamic> json) => _MenuConfig(
  items: (json['items'] as List<dynamic>)
      .map((e) => MenuConfigItemsItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MenuConfigToJson(_MenuConfig instance) =>
    <String, dynamic>{'items': instance.items};

_MenuConfigItemsItem _$MenuConfigItemsItemFromJson(Map<String, dynamic> json) =>
    _MenuConfigItemsItem(
      name: json['name'] as String,
      backgroundColor: json['background_color'] as String?,
    );

Map<String, dynamic> _$MenuConfigItemsItemToJson(
  _MenuConfigItemsItem instance,
) => <String, dynamic>{
  'name': instance.name,
  'background_color': instance.backgroundColor,
};
