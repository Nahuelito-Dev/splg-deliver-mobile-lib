// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
      quantity: (json['quantity'] as num).toInt(),
      percentage: (json['discountPercentage'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'discountPercentage': instance.percentage,
      'unitPrice': instance.unitPrice,
    };
