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
      postalCode: json['postalCode'] as String?,
      formattedAddress: json['formattedAddress'] as String?,
      additionalInstructions: json['additionalInstructions'] as String?,
      primary: json['isDefault'] as bool? ?? true,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address_id': instance.addressId,
      'street': instance.streetName,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'postalCode': instance.postalCode,
      'formattedAddress': instance.formattedAddress,
      'additionalInstructions': instance.additionalInstructions,
      'isDefault': instance.primary,
    };
