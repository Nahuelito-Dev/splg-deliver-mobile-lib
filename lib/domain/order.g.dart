// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['order_id'] as String,
  items: (json['order_items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total_amount'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
  paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['payment_method']),
  address: json['delivery_address'] == null
      ? null
      : Address.fromJson(json['delivery_address'] as Map<String, dynamic>),
  deliveryId: json['delivery_id'] as String?,
  deliveryName: json['delivery_name'] as String?,
  deliveryNotes: json['delivery_notes'] as String?,
  customerNotes: json['customer_notes'] as String?,
  deliveryWindowEnd: json['delivery_window_end'] as String?,
  actualDeliveryDate: json['actual_delivery_date'] == null
      ? null
      : DateTime.parse(json['actual_delivery_date'] as String),
  deliveryWindowStart: json['delivery_window_start'] as String?,
  requestedDeliveryDate: json['requested_delivery_date'] == null
      ? null
      : DateTime.parse(json['requested_delivery_date'] as String),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'total_amount': instance.total,
  'order_id': instance.id,
  'delivery_address': instance.address?.toJson(),
  'delivery_id': instance.deliveryId,
  'delivery_name': instance.deliveryName,
  'requested_delivery_date': instance.requestedDeliveryDate?.toIso8601String(),
  'actual_delivery_date': instance.actualDeliveryDate?.toIso8601String(),
  'status': _$OrderStatusEnumMap[instance.status]!,
  'order_items': instance.items.map((e) => e.toJson()).toList(),
  'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'created_at': instance.createdAt.toIso8601String(),
  'delivery_notes': instance.deliveryNotes,
  'customer_notes': instance.customerNotes,
  'delivery_window_start': instance.deliveryWindowStart,
  'delivery_window_end': instance.deliveryWindowEnd,
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.accepted: 'accepted',
  OrderStatus.outForDelivery: 'out_for_delivery',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.online: 'online',
};
