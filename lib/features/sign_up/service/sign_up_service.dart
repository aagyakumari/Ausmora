import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupService {
  final HiveService _hiveService = HiveService();

  Future<bool> signup(String name, String location, String birthDate, String birthTime, String email) async {
    String apiUrl = await _hiveService.getApiUrl() ?? '';

    final response = await http.post(
      Uri.parse('$apiUrl/signup'), // Update the endpoint as needed
      body: json.encode({
        'name': name,
        'location': location,
        'birthDate': birthDate,
        'birthTime': birthTime,
        'email': email,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Signup successful
      return true;
    } else {
      // Handle error
      print('Signup failed: ${response.body}');
      return false;
    }
  }
}
