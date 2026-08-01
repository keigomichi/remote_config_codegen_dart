// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeBannerConfig {

 List<HomeBannerConfigBannersItem> get banners;
/// Create a copy of HomeBannerConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeBannerConfigCopyWith<HomeBannerConfig> get copyWith => _$HomeBannerConfigCopyWithImpl<HomeBannerConfig>(this as HomeBannerConfig, _$identity);

  /// Serializes this HomeBannerConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeBannerConfig&&const DeepCollectionEquality().equals(other.banners, banners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(banners));

@override
String toString() {
  return 'HomeBannerConfig(banners: $banners)';
}


}

/// @nodoc
abstract mixin class $HomeBannerConfigCopyWith<$Res>  {
  factory $HomeBannerConfigCopyWith(HomeBannerConfig value, $Res Function(HomeBannerConfig) _then) = _$HomeBannerConfigCopyWithImpl;
@useResult
$Res call({
 List<HomeBannerConfigBannersItem> banners
});




}
/// @nodoc
class _$HomeBannerConfigCopyWithImpl<$Res>
    implements $HomeBannerConfigCopyWith<$Res> {
  _$HomeBannerConfigCopyWithImpl(this._self, this._then);

  final HomeBannerConfig _self;
  final $Res Function(HomeBannerConfig) _then;

/// Create a copy of HomeBannerConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? banners = null,}) {
  return _then(_self.copyWith(
banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<HomeBannerConfigBannersItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeBannerConfig].
extension HomeBannerConfigPatterns on HomeBannerConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeBannerConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeBannerConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeBannerConfig value)  $default,){
final _that = this;
switch (_that) {
case _HomeBannerConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeBannerConfig value)?  $default,){
final _that = this;
switch (_that) {
case _HomeBannerConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HomeBannerConfigBannersItem> banners)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeBannerConfig() when $default != null:
return $default(_that.banners);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HomeBannerConfigBannersItem> banners)  $default,) {final _that = this;
switch (_that) {
case _HomeBannerConfig():
return $default(_that.banners);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HomeBannerConfigBannersItem> banners)?  $default,) {final _that = this;
switch (_that) {
case _HomeBannerConfig() when $default != null:
return $default(_that.banners);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeBannerConfig implements HomeBannerConfig {
  const _HomeBannerConfig({required final  List<HomeBannerConfigBannersItem> banners}): _banners = banners;
  factory _HomeBannerConfig.fromJson(Map<String, dynamic> json) => _$HomeBannerConfigFromJson(json);

 final  List<HomeBannerConfigBannersItem> _banners;
@override List<HomeBannerConfigBannersItem> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}


/// Create a copy of HomeBannerConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeBannerConfigCopyWith<_HomeBannerConfig> get copyWith => __$HomeBannerConfigCopyWithImpl<_HomeBannerConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeBannerConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeBannerConfig&&const DeepCollectionEquality().equals(other._banners, _banners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_banners));

@override
String toString() {
  return 'HomeBannerConfig(banners: $banners)';
}


}

/// @nodoc
abstract mixin class _$HomeBannerConfigCopyWith<$Res> implements $HomeBannerConfigCopyWith<$Res> {
  factory _$HomeBannerConfigCopyWith(_HomeBannerConfig value, $Res Function(_HomeBannerConfig) _then) = __$HomeBannerConfigCopyWithImpl;
@override @useResult
$Res call({
 List<HomeBannerConfigBannersItem> banners
});




}
/// @nodoc
class __$HomeBannerConfigCopyWithImpl<$Res>
    implements _$HomeBannerConfigCopyWith<$Res> {
  __$HomeBannerConfigCopyWithImpl(this._self, this._then);

  final _HomeBannerConfig _self;
  final $Res Function(_HomeBannerConfig) _then;

/// Create a copy of HomeBannerConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? banners = null,}) {
  return _then(_HomeBannerConfig(
banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<HomeBannerConfigBannersItem>,
  ));
}


}


/// @nodoc
mixin _$HomeBannerConfigBannersItem {

 String get title;@JsonKey(name: 'background_color') String? get backgroundColor;
/// Create a copy of HomeBannerConfigBannersItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeBannerConfigBannersItemCopyWith<HomeBannerConfigBannersItem> get copyWith => _$HomeBannerConfigBannersItemCopyWithImpl<HomeBannerConfigBannersItem>(this as HomeBannerConfigBannersItem, _$identity);

  /// Serializes this HomeBannerConfigBannersItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeBannerConfigBannersItem&&(identical(other.title, title) || other.title == title)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,backgroundColor);

@override
String toString() {
  return 'HomeBannerConfigBannersItem(title: $title, backgroundColor: $backgroundColor)';
}


}

/// @nodoc
abstract mixin class $HomeBannerConfigBannersItemCopyWith<$Res>  {
  factory $HomeBannerConfigBannersItemCopyWith(HomeBannerConfigBannersItem value, $Res Function(HomeBannerConfigBannersItem) _then) = _$HomeBannerConfigBannersItemCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(name: 'background_color') String? backgroundColor
});




}
/// @nodoc
class _$HomeBannerConfigBannersItemCopyWithImpl<$Res>
    implements $HomeBannerConfigBannersItemCopyWith<$Res> {
  _$HomeBannerConfigBannersItemCopyWithImpl(this._self, this._then);

  final HomeBannerConfigBannersItem _self;
  final $Res Function(HomeBannerConfigBannersItem) _then;

/// Create a copy of HomeBannerConfigBannersItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? backgroundColor = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeBannerConfigBannersItem].
extension HomeBannerConfigBannersItemPatterns on HomeBannerConfigBannersItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeBannerConfigBannersItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeBannerConfigBannersItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeBannerConfigBannersItem value)  $default,){
final _that = this;
switch (_that) {
case _HomeBannerConfigBannersItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeBannerConfigBannersItem value)?  $default,){
final _that = this;
switch (_that) {
case _HomeBannerConfigBannersItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'background_color')  String? backgroundColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeBannerConfigBannersItem() when $default != null:
return $default(_that.title,_that.backgroundColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'background_color')  String? backgroundColor)  $default,) {final _that = this;
switch (_that) {
case _HomeBannerConfigBannersItem():
return $default(_that.title,_that.backgroundColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'background_color')  String? backgroundColor)?  $default,) {final _that = this;
switch (_that) {
case _HomeBannerConfigBannersItem() when $default != null:
return $default(_that.title,_that.backgroundColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeBannerConfigBannersItem implements HomeBannerConfigBannersItem {
  const _HomeBannerConfigBannersItem({required this.title, @JsonKey(name: 'background_color') this.backgroundColor});
  factory _HomeBannerConfigBannersItem.fromJson(Map<String, dynamic> json) => _$HomeBannerConfigBannersItemFromJson(json);

@override final  String title;
@override@JsonKey(name: 'background_color') final  String? backgroundColor;

/// Create a copy of HomeBannerConfigBannersItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeBannerConfigBannersItemCopyWith<_HomeBannerConfigBannersItem> get copyWith => __$HomeBannerConfigBannersItemCopyWithImpl<_HomeBannerConfigBannersItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeBannerConfigBannersItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeBannerConfigBannersItem&&(identical(other.title, title) || other.title == title)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,backgroundColor);

@override
String toString() {
  return 'HomeBannerConfigBannersItem(title: $title, backgroundColor: $backgroundColor)';
}


}

/// @nodoc
abstract mixin class _$HomeBannerConfigBannersItemCopyWith<$Res> implements $HomeBannerConfigBannersItemCopyWith<$Res> {
  factory _$HomeBannerConfigBannersItemCopyWith(_HomeBannerConfigBannersItem value, $Res Function(_HomeBannerConfigBannersItem) _then) = __$HomeBannerConfigBannersItemCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(name: 'background_color') String? backgroundColor
});




}
/// @nodoc
class __$HomeBannerConfigBannersItemCopyWithImpl<$Res>
    implements _$HomeBannerConfigBannersItemCopyWith<$Res> {
  __$HomeBannerConfigBannersItemCopyWithImpl(this._self, this._then);

  final _HomeBannerConfigBannersItem _self;
  final $Res Function(_HomeBannerConfigBannersItem) _then;

/// Create a copy of HomeBannerConfigBannersItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? backgroundColor = freezed,}) {
  return _then(_HomeBannerConfigBannersItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
