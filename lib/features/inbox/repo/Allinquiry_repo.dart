import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

Future<List<dynamic>> _fetchInquiries() async {
  try {
    final box = Hive.box('settings');
    String? token = await box.get('token');

    if (token == null) {
      throw Exception('Token is not available');
    }

    const url = 'http://145.223.23.200:3004/frontend/GuestInquiry/MyInquiries'; // Replace with actual URL

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['error_code'] == "0") {
        // Ensure that inquiries is a list
        var inquiries = responseData['data']['inquiries'];
        if (inquiries is List) {
          return inquiries;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(responseData['message']);
      }
    } else {
      throw Exception('Failed to load inquiries: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching inquiries: $e');
    return []; // Return an empty list in case of error
  }
}
