import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileRepo {
  final HiveService _hiveService = HiveService();

  // Variables to store profile data
  String? name;
  String? dob;
  String? tob;
  String? cityId;

  // API URLs
  static const String _updateProfileUrl = 'http://145.223.23.200:3004/frontend/Guests/UpdateGuestProfile';
  static const String _getProfileUrl = 'http://145.223.23.200:3004/frontend/Guests/Get';

  // Method to update guest profile
  Future<bool> updateGuestProfile(Map<String, dynamic> updateData) async {
    String? token = await _hiveService.getToken();

    try {
      final response = await http.post(
        Uri.parse(_updateProfileUrl),
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['error_code'] == "0") {
          return true; // Update successful
        } else {
          print('Error updating profile: ${responseData['message']}');
        }
      } else {
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during update: $e');
    }
    return false; // Update failed
  }

  // Method to get profile data
  Future<Map<String, dynamic>?> getProfile() async {
    String? token = await _hiveService.getToken();

    try {
      final response = await http.get(
        Uri.parse(_getProfileUrl),
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['error_code'] == "0") {
          var profileData = responseData['data']['item'];
          
          // Store profile data in variables
          name = profileData['name'];
          dob = profileData['dob'];
          tob = profileData['tob'];
          cityId = profileData['city_id'];
          

          // Return profile data if needed
          return profileData;
        } else {
          print('Error fetching profile: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during fetch: $e');
    }
    return null;
  }
  // Getters for profile data
  String? getName() => name;
  String? getDob() => dob;
  String? getTob() => tob;
  String? getCityId() => cityId;
}
