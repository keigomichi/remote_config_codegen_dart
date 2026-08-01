// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeBannerConfig _$HomeBannerConfigFromJson(Map<String, dynamic> json) =>
    _HomeBannerConfig(
      banners: (json['banners'] as List<dynamic>)
          .map(
            (e) =>
                HomeBannerConfigBannersItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$HomeBannerConfigToJson(_HomeBannerConfig instance) =>
    <String, dynamic>{'banners': instance.banners};

_HomeBannerConfigBannersItem _$HomeBannerConfigBannersItemFromJson(
  Map<String, dynamic> json,
) => _HomeBannerConfigBannersItem(
  title: json['title'] as String,
  backgroundColor: json['background_color'] as String?,
);

Map<String, dynamic> _$HomeBannerConfigBannersItemToJson(
  _HomeBannerConfigBannersItem instance,
) => <String, dynamic>{
  'title': instance.title,
  'background_color': instance.backgroundColor,
};
