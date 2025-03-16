import 'package:flutter_application_1/features/profile/model/profile_model.dart';
import 'package:flutter_application_1/hive/hive_service.dart'; // Assuming this is where you're storing the token
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileServices {
  // Method to fetch the user's profile
  static Future<ProfileModel?> getProfile() async {
    // Retrieve the token from your storage (e.g., using Hive)
    final token = await HiveService().getToken(); // Replace this with your actual token retrieval logic
    
    final response = await http.get(
      Uri.parse('http://your_url_here/frontend/Guests/Get'),
      headers: {'Authorization': token != null ? 'Bearer $token' : ''},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['error_code'] == "0") {
        return ProfileModel.fromJson(jsonResponse['data']['item']);
      } else {
        print('Error from API: ${jsonResponse['message']}');
        return null;
      }
    } else {
      // Handle error (e.g., log the error, show a message to the user)
      print('Failed to fetch profile, HTTP Status Code: ${response.statusCode}');
      return null;
    }
  }

  // // Method to pick an image from the gallery
  // static Future<File?> pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     return File(pickedFile.path);
  //   }
  //   return null; // Return null if no image was picked
  // }
}
