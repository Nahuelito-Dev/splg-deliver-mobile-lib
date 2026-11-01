import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Discount with _$Discount {
  Discount({required this.quantity, required this.percentage, this.unitPrice});

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountToJson(this);

  @override
  final int quantity;

  // El backend envía la clave 'discountPercentage' (no 'percentage').
  @override
  @JsonKey(name: 'discountPercentage')
  final double percentage;

  /// Precio unitario con esta promoción, calculado por el back con la misma
  /// regla con la que cobra el pedido. Null si el back no lo informa.
  @override
  final double? unitPrice;
}
