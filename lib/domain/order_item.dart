import 'gas_cylinder.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class OrderItem with _$OrderItem {
  OrderItem({required this.cylinder, this.quantity = 0, this.subtotal});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  @JsonKey(name: 'quantity')
  final int quantity;

  @override
  @JsonKey(name: 'gas_cylinder')
  final GasCylinder cylinder;

  /// Lo que cobra este renglón, calculado por el back (promoción incluida).
  /// Null en un renglón que todavía no es parte de un pedido.
  @override
  @JsonKey(name: 'subtotal')
  final double? subtotal;
}
