class GuestProfile {
  final String basicDescription;
  final String luckyColor;
  final String luckyGem;
  final String luckyNumber;
  final int rashiId;
  final String rashiName;
  final String compatibilityDescription;

  GuestProfile({
    required this.basicDescription,
    required this.luckyColor,
    required this.luckyGem,
    required this.luckyNumber,
    required this.rashiId,
    required this.rashiName,
    required this.compatibilityDescription,
  });

  factory GuestProfile.fromJson(Map<String, dynamic> json) {
    return GuestProfile(
      basicDescription: json['basic_description'],
      luckyColor: json['lucky_color'],
      luckyGem: json['lucky_gem'],
      luckyNumber: json['lucky_number'],
      rashiId: json['rashi_id'],
      rashiName: json['rashi_name'],
      compatibilityDescription: json['compatibility_description'],
    );
  }
}

class ProfileModel {
  final String name;
  final String email;
  final String dob;
  final String tob;
  final String cityId;
  final String city;
  final GuestProfile ? guestProfile;

  ProfileModel({
    required this.name,
    required this.email,
    required this.dob,
    required this.tob,
    required this.cityId,
    required this.city,
    this.guestProfile,
  });

 factory ProfileModel.fromJson(Map<String, dynamic> json) {
  return ProfileModel(
    name: json['name'] ?? 'No name available',
    email: json['email'] ?? '',
    cityId: json['city_id'] ?? '',
    dob: json['dob'] ?? '',
    tob: json['tob'] ?? '',
    city: json['city'] ?? '',
    guestProfile: json['guest_profile'] != null 
        ? GuestProfile.fromJson(json['guest_profile']) 
        : null, // Handle null case
  );
}

}
