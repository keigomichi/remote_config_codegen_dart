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
mixin _$MenuConfig {

 List<MenuConfigItemsItem> get items;
/// Create a copy of MenuConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuConfigCopyWith<MenuConfig> get copyWith => _$MenuConfigCopyWithImpl<MenuConfig>(this as MenuConfig, _$identity);

  /// Serializes this MenuConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuConfig&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MenuConfig(items: $items)';
}


}

/// @nodoc
abstract mixin class $MenuConfigCopyWith<$Res>  {
  factory $MenuConfigCopyWith(MenuConfig value, $Res Function(MenuConfig) _then) = _$MenuConfigCopyWithImpl;
@useResult
$Res call({
 List<MenuConfigItemsItem> items
});




}
/// @nodoc
class _$MenuConfigCopyWithImpl<$Res>
    implements $MenuConfigCopyWith<$Res> {
  _$MenuConfigCopyWithImpl(this._self, this._then);

  final MenuConfig _self;
  final $Res Function(MenuConfig) _then;

/// Create a copy of MenuConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MenuConfigItemsItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuConfig].
extension MenuConfigPatterns on MenuConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuConfig value)  $default,){
final _that = this;
switch (_that) {
case _MenuConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuConfig value)?  $default,){
final _that = this;
switch (_that) {
case _MenuConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MenuConfigItemsItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuConfig() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MenuConfigItemsItem> items)  $default,) {final _that = this;
switch (_that) {
case _MenuConfig():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MenuConfigItemsItem> items)?  $default,) {final _that = this;
switch (_that) {
case _MenuConfig() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuConfig implements MenuConfig {
  const _MenuConfig({required final  List<MenuConfigItemsItem> items}): _items = items;
  factory _MenuConfig.fromJson(Map<String, dynamic> json) => _$MenuConfigFromJson(json);

 final  List<MenuConfigItemsItem> _items;
@override List<MenuConfigItemsItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MenuConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuConfigCopyWith<_MenuConfig> get copyWith => __$MenuConfigCopyWithImpl<_MenuConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuConfig&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MenuConfig(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MenuConfigCopyWith<$Res> implements $MenuConfigCopyWith<$Res> {
  factory _$MenuConfigCopyWith(_MenuConfig value, $Res Function(_MenuConfig) _then) = __$MenuConfigCopyWithImpl;
@override @useResult
$Res call({
 List<MenuConfigItemsItem> items
});




}
/// @nodoc
class __$MenuConfigCopyWithImpl<$Res>
    implements _$MenuConfigCopyWith<$Res> {
  __$MenuConfigCopyWithImpl(this._self, this._then);

  final _MenuConfig _self;
  final $Res Function(_MenuConfig) _then;

/// Create a copy of MenuConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MenuConfig(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MenuConfigItemsItem>,
  ));
}


}


/// @nodoc
mixin _$MenuConfigItemsItem {

 String get name;@JsonKey(name: 'background_color') String? get backgroundColor;
/// Create a copy of MenuConfigItemsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuConfigItemsItemCopyWith<MenuConfigItemsItem> get copyWith => _$MenuConfigItemsItemCopyWithImpl<MenuConfigItemsItem>(this as MenuConfigItemsItem, _$identity);

  /// Serializes this MenuConfigItemsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuConfigItemsItem&&(identical(other.name, name) || other.name == name)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,backgroundColor);

@override
String toString() {
  return 'MenuConfigItemsItem(name: $name, backgroundColor: $backgroundColor)';
}


}

/// @nodoc
abstract mixin class $MenuConfigItemsItemCopyWith<$Res>  {
  factory $MenuConfigItemsItemCopyWith(MenuConfigItemsItem value, $Res Function(MenuConfigItemsItem) _then) = _$MenuConfigItemsItemCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'background_color') String? backgroundColor
});




}
/// @nodoc
class _$MenuConfigItemsItemCopyWithImpl<$Res>
    implements $MenuConfigItemsItemCopyWith<$Res> {
  _$MenuConfigItemsItemCopyWithImpl(this._self, this._then);

  final MenuConfigItemsItem _self;
  final $Res Function(MenuConfigItemsItem) _then;

/// Create a copy of MenuConfigItemsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? backgroundColor = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuConfigItemsItem].
extension MenuConfigItemsItemPatterns on MenuConfigItemsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuConfigItemsItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuConfigItemsItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuConfigItemsItem value)  $default,){
final _that = this;
switch (_that) {
case _MenuConfigItemsItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuConfigItemsItem value)?  $default,){
final _that = this;
switch (_that) {
case _MenuConfigItemsItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'background_color')  String? backgroundColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuConfigItemsItem() when $default != null:
return $default(_that.name,_that.backgroundColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'background_color')  String? backgroundColor)  $default,) {final _that = this;
switch (_that) {
case _MenuConfigItemsItem():
return $default(_that.name,_that.backgroundColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'background_color')  String? backgroundColor)?  $default,) {final _that = this;
switch (_that) {
case _MenuConfigItemsItem() when $default != null:
return $default(_that.name,_that.backgroundColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuConfigItemsItem implements MenuConfigItemsItem {
  const _MenuConfigItemsItem({required this.name, @JsonKey(name: 'background_color') this.backgroundColor});
  factory _MenuConfigItemsItem.fromJson(Map<String, dynamic> json) => _$MenuConfigItemsItemFromJson(json);

@override final  String name;
@override@JsonKey(name: 'background_color') final  String? backgroundColor;

/// Create a copy of MenuConfigItemsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuConfigItemsItemCopyWith<_MenuConfigItemsItem> get copyWith => __$MenuConfigItemsItemCopyWithImpl<_MenuConfigItemsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuConfigItemsItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuConfigItemsItem&&(identical(other.name, name) || other.name == name)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,backgroundColor);

@override
String toString() {
  return 'MenuConfigItemsItem(name: $name, backgroundColor: $backgroundColor)';
}


}

/// @nodoc
abstract mixin class _$MenuConfigItemsItemCopyWith<$Res> implements $MenuConfigItemsItemCopyWith<$Res> {
  factory _$MenuConfigItemsItemCopyWith(_MenuConfigItemsItem value, $Res Function(_MenuConfigItemsItem) _then) = __$MenuConfigItemsItemCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'background_color') String? backgroundColor
});




}
/// @nodoc
class __$MenuConfigItemsItemCopyWithImpl<$Res>
    implements _$MenuConfigItemsItemCopyWith<$Res> {
  __$MenuConfigItemsItemCopyWithImpl(this._self, this._then);

  final _MenuConfigItemsItem _self;
  final $Res Function(_MenuConfigItemsItem) _then;

/// Create a copy of MenuConfigItemsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? backgroundColor = freezed,}) {
  return _then(_MenuConfigItemsItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,backgroundColor: freezed == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
