import 'package:freezed_annotation/freezed_annotation.dart';

import 'address.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Customer with _$Customer {
  Customer({
    required this.customerId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.blocked,
    this.addresses = const [],
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  @JsonKey(name: 'user_id')
  final String customerId;

  @override
  @JsonKey(name: 'full_name')
  final String fullName;

  @override
  @JsonKey(name: 'email')
  final String email;

  @override
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @override
  @JsonKey(name: 'blocked')
  final bool blocked;

  @override
  @JsonKey(name: 'addresses')
  final List<Address> addresses;

  String firstName() {
    if (fullName.isNotEmpty) {
      final names = fullName.split(' ');
      if (names.isNotEmpty) {
        return names.first;
      }
    }

    return '';
  }
}
