import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Discount with _$Discount {

  Discount({required this.quantity, required this.percentage});
  
  factory Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);

  Map<String, dynamic> toJson() => _$DiscountToJson(this);

  @override
  final int quantity;
  
  @override
  final double percentage;
}