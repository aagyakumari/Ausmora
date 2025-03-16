import 'package:flutter_application_1/features/horoscope/model/horoscope_model.dart';
import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class HoroscopeRepository {
  final HiveService hiveService = HiveService(); // Create an instance of HiveService

  // Function to fetch horoscope data from the API
  Future<Horoscope> fetchHoroscopeData(String date) async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      final url = 'http://145.223.23.200:3004/frontend/Guests/GetDashboardData?date=$date';
      // final url = 'http://145.223.23.200:3004/frontend/Guests/GetDashboardData?date=2024-11-24';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['horoscope'];
        final horoscope = Horoscope.fromJson(data);

        // Save horoscope data in Hive
        await hiveService.saveHoroscopeData(horoscope); // Save the horoscope data

        return horoscope;
      } else {
        throw Exception('Failed to load horoscope data');
      }
    } catch (e) {
      throw Exception('Error fetching horoscope data: $e');
    }
  }
}
