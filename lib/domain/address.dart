import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Address with _$Address {
  Address({
    required this.addressId,
    required this.streetName,
    this.latitude,
    this.longitude,
    this.city,
    this.postalCode,
    this.formattedAddress,
    this.additionalInstructions,
    this.primary = true,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  @JsonKey(name: 'address_id')
  final String addressId;

  @override
  @JsonKey(name: 'street')
  final String streetName;

  @override
  @JsonKey(name: 'city')
  final String? city;

  @override
  @JsonKey(name: 'latitude')
  final String? latitude;

  @override
  @JsonKey(name: 'longitude')
  final String? longitude;
  
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;

  @override
  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;

  @override
  @JsonKey(name: 'additional_instructions')
  final String? additionalInstructions;

  @override
  @JsonKey(name: 'isDefault')
  final bool primary;  
}
