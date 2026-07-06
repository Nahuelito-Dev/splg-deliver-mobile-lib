// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gas_cylinder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GasCylinder _$GasCylinderFromJson(Map<String, dynamic> json) => GasCylinder(
      id: json['gas_cylinder_id'] as String,
      type: json['type'] as String,
      price: _parsePrice(json['price']),
      active: json['isActive'] as bool,
      weight: json['weight'] as String,
      description: json['description'] as String,
      discounts: (json['promotions'] as List<dynamic>?)
              ?.map((e) => Discount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GasCylinderToJson(GasCylinder instance) =>
    <String, dynamic>{
      'gas_cylinder_id': instance.id,
      'type': instance.type,
      'weight': instance.weight,
      'price': instance.price,
      'isActive': instance.active,
      'description': instance.description,
      'promotions': instance.discounts?.map((e) => e.toJson()).toList(),
    };
