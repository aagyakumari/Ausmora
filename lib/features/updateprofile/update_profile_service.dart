import 'dart:convert';
import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;

class UpdateProfileService {
  final String apiUrl = 'http://145.223.23.200:3004/frontend/Guests/UpdateProfile';

  Future<bool> updateProfile(String name, String cityId, String dob, String tob) async {
    try {
      // Get the token from Hive
      String? token = await HiveService().getToken(); // Implement this method in your HiveService

      // Set up headers with token
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Use the correct token format if needed
      };

      // Create the request body
      final body = jsonEncode({
        'name': name,
        'city_id': cityId,
        'dob': dob,
        'tob': tob,
      });

      print('Request Body: $body'); // Add this line for debugging
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      // Check the response
      if (response.statusCode == 200) {
        // Handle successful response
        return true;
      } else {
        // Handle error response
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
