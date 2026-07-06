// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {
  double get total;
  String get id;
  Address? get address;
  String? get deliveryId;
  String? get deliveryName;
  DateTime? get requestedDeliveryDate;
  DateTime? get actualDeliveryDate;
  OrderStatus get status;
  List<OrderItem> get items;
  PaymentMethod get paymentMethod;
  DateTime get createdAt;
  String? get deliveryNotes;
  String? get customerNotes;
  String? get deliveryWindowStart;
  String? get deliveryWindowEnd;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderCopyWith<Order> get copyWith =>
      _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Order &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.deliveryId, deliveryId) ||
                other.deliveryId == deliveryId) &&
            (identical(other.deliveryName, deliveryName) ||
                other.deliveryName == deliveryName) &&
            (identical(other.requestedDeliveryDate, requestedDeliveryDate) ||
                other.requestedDeliveryDate == requestedDeliveryDate) &&
            (identical(other.actualDeliveryDate, actualDeliveryDate) ||
                other.actualDeliveryDate == actualDeliveryDate) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deliveryNotes, deliveryNotes) ||
                other.deliveryNotes == deliveryNotes) &&
            (identical(other.customerNotes, customerNotes) ||
                other.customerNotes == customerNotes) &&
            (identical(other.deliveryWindowStart, deliveryWindowStart) ||
                other.deliveryWindowStart == deliveryWindowStart) &&
            (identical(other.deliveryWindowEnd, deliveryWindowEnd) ||
                other.deliveryWindowEnd == deliveryWindowEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      total,
      id,
      address,
      deliveryId,
      deliveryName,
      requestedDeliveryDate,
      actualDeliveryDate,
      status,
      const DeepCollectionEquality().hash(items),
      paymentMethod,
      createdAt,
      deliveryNotes,
      customerNotes,
      deliveryWindowStart,
      deliveryWindowEnd);

  @override
  String toString() {
    return 'Order(total: $total, id: $id, address: $address, deliveryId: $deliveryId, deliveryName: $deliveryName, requestedDeliveryDate: $requestedDeliveryDate, actualDeliveryDate: $actualDeliveryDate, status: $status, items: $items, paymentMethod: $paymentMethod, createdAt: $createdAt, deliveryNotes: $deliveryNotes, customerNotes: $customerNotes, deliveryWindowStart: $deliveryWindowStart, deliveryWindowEnd: $deliveryWindowEnd)';
  }
}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) =
      _$OrderCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      List<OrderItem> items,
      double total,
      OrderStatus status,
      DateTime createdAt,
      PaymentMethod paymentMethod,
      Address? address,
      String? deliveryId,
      String? deliveryName,
      String? deliveryNotes,
      String? customerNotes,
      String? deliveryWindowEnd,
      DateTime? actualDeliveryDate,
      String? deliveryWindowStart,
      DateTime? requestedDeliveryDate});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? total = null,
    Object? status = null,
    Object? createdAt = null,
    Object? paymentMethod = null,
    Object? address = freezed,
    Object? deliveryId = freezed,
    Object? deliveryName = freezed,
    Object? deliveryNotes = freezed,
    Object? customerNotes = freezed,
    Object? deliveryWindowEnd = freezed,
    Object? actualDeliveryDate = freezed,
    Object? deliveryWindowStart = freezed,
    Object? requestedDeliveryDate = freezed,
  }) {
    return _then(Order(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address?,
      deliveryId: freezed == deliveryId
          ? _self.deliveryId
          : deliveryId // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryName: freezed == deliveryName
          ? _self.deliveryName
          : deliveryName // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryNotes: freezed == deliveryNotes
          ? _self.deliveryNotes
          : deliveryNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      customerNotes: freezed == customerNotes
          ? _self.customerNotes
          : customerNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryWindowEnd: freezed == deliveryWindowEnd
          ? _self.deliveryWindowEnd
          : deliveryWindowEnd // ignore: cast_nullable_to_non_nullable
              as String?,
      actualDeliveryDate: freezed == actualDeliveryDate
          ? _self.actualDeliveryDate
          : actualDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveryWindowStart: freezed == deliveryWindowStart
          ? _self.deliveryWindowStart
          : deliveryWindowStart // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedDeliveryDate: freezed == requestedDeliveryDate
          ? _self.requestedDeliveryDate
          : requestedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>() {
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>() {
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>() {
    final _that = this;
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on
