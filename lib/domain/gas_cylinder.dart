import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jennygas_lib/domain/discount.dart';

part 'gas_cylinder.freezed.dart';
part 'gas_cylinder.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class GasCylinder with _$GasCylinder {
  GasCylinder({
    required this.id,
    required this.type,
    required this.price,
    required this.active,
    required this.weight,
    required this.description,
    this.discounts = const [],
  });

  factory GasCylinder.fromJson(Map<String, dynamic> json) =>
      _$GasCylinderFromJson(json);

  Map<String, dynamic> toJson() => _$GasCylinderToJson(this);

  @override
  @JsonKey(name: "gas_cylinder_id")
  final String id;

  @override
  @JsonKey(name: "type")
  final String type;

  @override
  @JsonKey(name: "weight", fromJson: _parseWeight)
  final String weight;

  @override
  @JsonKey(name: "price", fromJson: _parsePrice)
  final double price;

  @override
  @JsonKey(name: "isActive", defaultValue: true)
  final bool active;

  @override
  @JsonKey(name: "description")
  final String description;

  @override
  @JsonKey(name: "promotions")
  final List<Discount>? discounts;
  
  // @override
  // @JsonKey(name: "exchange_price")
  // final double exchangePrice;

  // @override
  // @JsonKey(includeFromJson: false, includeToJson: true)
  // final bool exchange;
  
  // @override
  // @JsonKey(name: "stock")
  // final int stock;
}

double _parsePrice(dynamic value) {
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  } else if (value is num) {
    return value.toDouble();
  } else {
    return 0.0;
  }
}

// El backend a veces manda "weight" como número (ej. 10) y a veces como
// String (ej. "10"). Toleramos ambos formatos para no romper el parseo
// de listas completas por un solo item mal tipado.
String _parseWeight(dynamic value) {
  if (value == null) return '';
  return value.toString();
}
