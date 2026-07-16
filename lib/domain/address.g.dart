// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      addressId: json['address_id'] as String,
      streetName: json['street'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      additionalInstructions: json['additional_instructions'] as String?,
      primary: json['isDefault'] as bool? ?? true,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address_id': instance.addressId,
      'street': instance.streetName,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'postal_code': instance.postalCode,
      'formatted_address': instance.formattedAddress,
      'additional_instructions': instance.additionalInstructions,
      'isDefault': instance.primary,
    };
