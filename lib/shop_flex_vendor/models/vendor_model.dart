class VendorOwnersModel {
  final bool approved;
  final String businessName;
  final String cityValue;
  final String countryValue;
  final String emailAddress;
  final String phoneNumber;
  final String stateValue;
  final String vendorImageURL;
  final String vendorId;

  VendorOwnersModel({
    required this.approved,
    required this.businessName,
    required this.cityValue,
    required this.countryValue,
    required this.emailAddress,
    required this.phoneNumber,
    required this.stateValue,
    required this.vendorImageURL,
    required this.vendorId,
  });

  VendorOwnersModel.fromJson(Map<String, Object?> json)
      : approved = json['approved'] as bool? ?? false,
        businessName = json['businessName'] as String? ?? '',
        cityValue = json['cityValue'] as String? ?? '',
        countryValue = json['countryValue'] as String? ?? '',
        emailAddress = json['emailAddress'] as String? ?? '',
        phoneNumber = json['phoneNumber'] as String? ?? '',
        stateValue = json['stateValue'] as String? ?? '',
        vendorImageURL = json['vendorImageURL'] as String? ?? '',
        vendorId = json['vendorId'] as String? ?? '';

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'businessName': businessName,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'stateValue': stateValue,
      'vendorImageURL': vendorImageURL,
      'vendorId': vendorId,
    };
  }
}
