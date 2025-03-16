import 'package:flutter_application_1/features/partner/model/partner_details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PartnerDetailsRepository {
  final String _apiUrl = 'https://your-api-url.com/submit';

  Future<void> submitDetails(PartnerDetailsModel details) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': details.name,
          'location': details.location,
          'birthDate': details.birthDate,
          'birthTime': details.birthTime,
          'question': details.question,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success
      } else {
        // Handle failure
        throw Exception('Failed to submit details');
      }
    } catch (e) {
      // Handle error
      print(e);
    }
  }
}