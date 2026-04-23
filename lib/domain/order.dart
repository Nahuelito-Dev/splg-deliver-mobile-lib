import 'package:freezed_annotation/freezed_annotation.dart';

import 'address.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Order with _$Order {
  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    this.address,
    this.deliveryId,
    this.deliveryName,
    this.deliveryNotes,
    this.customerNotes,
    this.deliveryWindowEnd,
    this.actualDeliveryDate,
    this.deliveryWindowStart,
    this.requestedDeliveryDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  @JsonKey(name: 'total_amount')
  final double total;

  @override
  @JsonKey(name: 'order_id')
  final String id;

  @override
  @JsonKey(name: 'delivery_address')
  final Address? address;

  @override
  @JsonKey(name: 'delivery_id')
  final String? deliveryId;

  @override
  @JsonKey(name: 'delivery_name')
  final String? deliveryName;

  @override
  @JsonKey(name: 'requested_delivery_date')
  final DateTime? requestedDeliveryDate;
  
  @override
  @JsonKey(name: 'actual_delivery_date')
  final DateTime? actualDeliveryDate;

  @override
  @JsonKey(name: 'status')
  final OrderStatus status;

  @override
  @JsonKey(name: 'order_items')
  final List<OrderItem> items;

  @override
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  @JsonKey(name: 'delivery_notes')
  final String? deliveryNotes;

  @override
  @JsonKey(name: 'customer_notes')
  final String? customerNotes;

  @override
  @JsonKey(name: 'delivery_window_start')
  final String? deliveryWindowStart;

  @override
  @JsonKey(name: 'delivery_window_end')
  final String? deliveryWindowEnd;

  bool isPending() => status == OrderStatus.pending;

  bool isAccepted() => status == OrderStatus.accepted;

  bool isOutForDelivery() => status == OrderStatus.outForDelivery;

  bool isDelivered() => status == OrderStatus.delivered;

  bool isCancelled() => status == OrderStatus.cancelled;
}

@JsonEnum()
enum OrderStatus {
  @JsonValue('pending')
  pending('Pendientes'),

  @JsonValue('accepted')
  accepted('Aceptada'),

  @JsonValue('out_for_delivery')
  outForDelivery('En camino'),

  @JsonValue('delivered')
  delivered('Entregada'),

  @JsonValue('cancelled')
  cancelled('Cancelada');

  const OrderStatus(this.label);
  final String label;
}

@JsonEnum()
enum PaymentMethod {
  @JsonValue('cash')
  cash('Efectivo'),
  @JsonValue('online')
  online('Pago online');

  const PaymentMethod(this.label);
  final String label;
}
