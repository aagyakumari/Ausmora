class UserModel {
  String name;
  String cityId; // Change location to city_id
  String dob; // Change birthDate to dob
  String tob; // Change birthTime to tob
  String email;
  bool isLogin; // Add this field

  UserModel({
    required this.name,
    required this.cityId, // Updated parameter name
    required this.dob, // Updated parameter name
    required this.tob, // Updated parameter name
    required this.email,
    this.isLogin = false, // Default to false
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'city_id': cityId, // Change this to city_id
      'dob': dob, // Change this to dob
      'tob': tob, // Change this to tob
      'is_login': isLogin, // Add is_login
    };
  }
}
