import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/updateprofile/update_profile_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  bool _isLoading = true;
  bool _isEditing = false;
  String? _errorMessage;
  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? _guestProfileData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _tobController = TextEditingController();

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');
      String url = 'http://145.223.23.200:3004/frontend/Guests/Get';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['error_code'] == "0") {
          setState(() {
            _profileData = responseData['data']['item'];
            _guestProfileData = _profileData!['guest_profile'];
             // Save guest_profile to Hive
            box.put('guest_profile', _guestProfileData);
            _nameController.text = _profileData!['name'] ?? '';
            _locationController.text = _profileData!['city_id'] ?? '';
            _dobController.text = _profileData!['dob'] ?? '';
            _tobController.text = _profileData!['tob'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = responseData['message'];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load profile data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

 // Update Profile Function
void _updateProfile() async {
  final updateProfileService = UpdateProfileService();

  bool success = await updateProfileService.updateProfile(
    _nameController.text,
    _locationController.text,
    _dobController.text, // For date of birth
    _tobController.text, // For time of birth
  );

  if (success) {
    // Show success message
    if (!context.mounted) return; // Handle context safety
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Color(0xFFFF9933),
      ),
    );
    _fetchProfileData();
    setState(() {
      _isEditing = false;
    });
  } else {
    // Show failure message
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to update profile. Please try again.'),
      ),
    );
  }
}

// Date Picker Function
Future<void> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    setState(() {
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    });
  }
}

// Time Picker Function
Future<void> _selectTime(BuildContext context) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      _tobController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double padding = screenWidth * 0.05; // 5% of screen width
    final double spacing = screenHeight * 0.02; // 2% of screen height
    final double fontSize = screenWidth * 0.04; // 4% of screen width
    final double buttonPadding = screenWidth * 0.1; // 10% of screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF9933),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? Center(
                            child: Text(_errorMessage!,
                                style: TextStyle(
                                    color: Colors.red, fontSize: fontSize)),
                          )
                        : _buildProfileUI(
                            fontSize, spacing, screenWidth, padding),
                SizedBox(height: screenHeight * 0.1), // Extra space for buttons
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, double fontSize) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9933),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }

 Widget _buildProfileUI(double fontSize, double spacing, double buttonPadding, double screenWidth) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
            'Name', _nameController, Icons.person, _isEditing, fontSize),
        SizedBox(height: spacing),
        _buildTextField('City ID', _locationController, Icons.location_city,
            _isEditing, fontSize),
        SizedBox(height: spacing),
        _buildTextField('Date of Birth (YYYY-MM-DD)', _dobController,
            Icons.cake, _isEditing, fontSize, onTap: () => _selectDate(context)),
        SizedBox(height: spacing),
        _buildTextField('Time of Birth (HH:mm)', _tobController,
            Icons.access_time, _isEditing, fontSize, onTap: () => _selectTime(context)),
        SizedBox(height: spacing * 1.5),
        
        // Button placed before the guest profile UI
        _isEditing
            ? _buildButton('Update Profile', _updateProfile, fontSize)
            : _buildButton(
                'Edit Profile',
                () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                fontSize,
              ),
        
        SizedBox(height: spacing * 1.5),

        _guestProfileData == null
            ? Center(
                child: Text('Profile is being generated...',
                    style: TextStyle(color: Colors.orange, fontSize: fontSize)),
              )
            : _buildGuestProfileUI(fontSize, spacing, screenWidth),

        SizedBox(height: spacing * 1.5),
      ],
    ),
  );
}


  Widget _buildGuestProfileUI(
      double fontSize, double spacing, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Profile Details:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        SizedBox(height: spacing / 2),

        // Basic Description
        _buildGuestProfileDetail(
          label: 'Basic Description',
          value: _guestProfileData!['basic_description'] ?? '',
          fontSize: fontSize,
          isExpandable: true, // Indicating that this field is expandable
          screenWidth: screenWidth,
        ),

        // Lucky Color
        _buildGuestProfileDetail(
          label: 'Lucky Color',
          value: _guestProfileData!['lucky_color'] ?? '',
          fontSize: fontSize,
        ),

        // Lucky Gem
        _buildGuestProfileDetail(
          label: 'Lucky Gem',
          value: _guestProfileData!['lucky_gem'] ?? '',
          fontSize: fontSize,
        ),

        // Lucky Number
        _buildGuestProfileDetail(
          label: 'Lucky Number',
          value: _guestProfileData!['lucky_number'] ?? '',
          fontSize: fontSize,
        ),

        // Rashi Name
        _buildGuestProfileDetail(
          label: 'Rashi Name',
          value: _guestProfileData!['rashi_name'] ?? '',
          fontSize: fontSize,
        ),

        // Compatibility
        _buildGuestProfileDetail(
          label: 'Compatibility',
          value: _guestProfileData!['compatibility_description'] ?? '',
          fontSize: fontSize,
        ),
      ],
    );
  }

Widget _buildGuestProfileDetail({
  required String label,
  required String value,
  required double fontSize,
  bool isExpandable = false,
  double? screenWidth,
}) {
  const int maxLength = 100; // Define the maximum number of characters before truncating
  bool isTruncated = value.length > maxLength && !_isExpanded;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: fontSize * 0.4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),

        // Value
        SizedBox(height: fontSize * 0.2), // Small space between label and value
        Text(
          isTruncated ? '${value.substring(0, maxLength)}...' : value,
          style: TextStyle(fontSize: fontSize),
        ),

        // View More / View Less toggle
        if (value.length > maxLength)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle between expanded and collapsed
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: fontSize * 0.4),
              child: Text(
                _isExpanded ? 'View Less' : 'View More',
                style: TextStyle(color: const Color(0xFFFF9933), fontSize: fontSize),
              ),
            ),
          ),
      ],
    ),
  );
}


Widget _buildTextField(
  String label,
  TextEditingController controller,
  IconData icon,
  bool isEnabled,
  double fontSize, {
  void Function()? onTap, // Add an optional onTap parameter
}) {
  return TextFormField(
    controller: controller,
    enabled: isEnabled,
    readOnly: onTap != null, // Make field read-only if onTap is provided
    onTap: onTap, // Assign the onTap logic
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      labelStyle: TextStyle(fontSize: fontSize),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide:
            const BorderSide(color: Color(0xFFFF9933)), // Set border color
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
            color: Color(0xFFFF9933)), // Set border color for enabled state
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
            color: Color(0xFFFF9933)), // Set border color for focused state
      ),
    ),
  );
}
}
