import 'package:flutter_application_1/features/auspicious_time/model/auspicious_time_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class AuspiciousRepository {
  // Function to fetch auspicious data from the API
  Future<Auspicious> fetchAuspiciousData(String date) async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      // Using the dynamic date in the URL
      final url = 'http://145.223.23.200:3004/frontend/Guests/GetDashboardData?date=$date';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        // Parse the response and return the full Auspicious model
        final data = json.decode(response.body)['data']['auspicious'] ;
           // Print the data to debug and inspect it
        print('Fetched auspicious data: $data');
        // Assuming Auspicious.fromJson expects the entire 'auspicious' object
        return Auspicious.fromJson(data);
      } else {
        throw Exception('Failed to load auspicious data');
      }
    } catch (e) {
      throw Exception('Error fetching auspicious data: $e');
    }
  }
}