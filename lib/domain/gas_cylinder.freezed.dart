// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gas_cylinder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GasCylinder {

 String get id; String get type; String get weight; double get price; bool get active; String get description; List<Discount>? get discounts;
/// Create a copy of GasCylinder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GasCylinderCopyWith<GasCylinder> get copyWith => _$GasCylinderCopyWithImpl<GasCylinder>(this as GasCylinder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GasCylinder&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.price, price) || other.price == price)&&(identical(other.active, active) || other.active == active)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.discounts, discounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,weight,price,active,description,const DeepCollectionEquality().hash(discounts));

@override
String toString() {
  return 'GasCylinder(id: $id, type: $type, weight: $weight, price: $price, active: $active, description: $description, discounts: $discounts)';
}


}

/// @nodoc
abstract mixin class $GasCylinderCopyWith<$Res>  {
  factory $GasCylinderCopyWith(GasCylinder value, $Res Function(GasCylinder) _then) = _$GasCylinderCopyWithImpl;
@useResult
$Res call({
 String id, String type, double price, bool active, String weight, String description, List<Discount>? discounts
});




}
/// @nodoc
class _$GasCylinderCopyWithImpl<$Res>
    implements $GasCylinderCopyWith<$Res> {
  _$GasCylinderCopyWithImpl(this._self, this._then);

  final GasCylinder _self;
  final $Res Function(GasCylinder) _then;

/// Create a copy of GasCylinder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? price = null,Object? active = null,Object? weight = null,Object? description = null,Object? discounts = freezed,}) {
  return _then(GasCylinder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,discounts: freezed == discounts ? _self.discounts : discounts // ignore: cast_nullable_to_non_nullable
as List<Discount>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GasCylinder].
extension GasCylinderPatterns on GasCylinder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
