import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user_model.dart';

class SignUpRepo {
  final HiveService _hiveService = HiveService();
  String? _otp; // Variable to store the OTP
  final String apiUrl =
      'http://145.223.23.200:3004/frontend/Guests/login'; // API URL for both signup and login
  bool state = false;

  // Method to handle user signup
  Future<bool> signUp(UserModel user) async {
    String? token = await _hiveService.getToken();

    state = false;
    try {
      // Make POST request for signup
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'city_id': user.cityId,
          'dob': user.dob,
          'tob': user.tob,
          'is_login': state, // Set is_login to false for signup
        }),
      );

      // Check response status
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Handle success and error codes
        if (responseData['error_code'] != "0") {
          return false; // Signup failed
        }
        // Store token if present
        if (responseData['token'] != null) {
          await _hiveService.saveToken(responseData['token']);
        }
        _otp = responseData['otp']; // Save OTP during signup
        return true; // Successful signup
      } else {
        print('Signup failed with status code: ${response.statusCode}');
        return false; // API call failed
      }
    } catch (e) {
      print('Error during signup: $e');
      return false; // Handle any exceptions
    }
  }

  // Method to handle user login
  Future<bool> login(String email) async {
    String? token = await _hiveService.getToken();

    state = true;
    try {
      // Make POST request for login
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': email,
          'is_login': state, // Set is_login to true for login
        }),
      );

      // Check response status
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Handle success and error codes
        if (responseData['error_code'] != "0") {
          return false; // Login failed
        }
        // Store token if present
        if (responseData['token'] != null) {
          await _hiveService.saveToken(responseData['token']);
        }
        return true; // Successful login
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return false; // API call failed
      }
    } catch (e) {
      print('Error during login: $e');
      return false; // Handle any exceptions
    }
  }

  bool? getState() {
    return state;
  }
  // // Method to retrieve the OTP
  // String? getOtp() {
  //   return _otp; // Return the stored OTP
  // }

  // Method to check if the email is already registered
  Future<bool> checkEmail(String email) async {
    // You can choose to implement this if needed or remove it
    // The URL is the same for now.
    return false; // Not implemented
  }
}
