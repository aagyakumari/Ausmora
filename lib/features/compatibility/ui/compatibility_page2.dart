import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/buildcirclewithname.dart';
import 'package:flutter_application_1/components/categorydropdown.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/components/zodiac.utils.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:flutter_application_1/features/ask_a_question/repo/ask_a_question_repo.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/profile/model/profile_model.dart';
import 'package:flutter_application_1/features/profile/repo/profile_repo.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompatibilityPage2 extends StatefulWidget {
    final bool showBundleQuestions;

  const CompatibilityPage2({super.key, required this.showBundleQuestions});


  @override
  _CompatibilityPage2State createState() => _CompatibilityPage2State();
}

class _CompatibilityPage2State extends State<CompatibilityPage2> {
  final Color primaryColor = const Color(0xFFFF9933);
  ProfileModel? _profile;
  Map<String, dynamic>? _compatibilityData;
  bool _isLoading = true;
  String? _errorMessage;
  String? _person2Name = 'Person 2'; // Variable to store Person 2's name
  late Future<List<Question>>
      _questionsFuture; // Future for Horoscope questions
  final AskQuestionRepository _askQuestionRepository =
      AskQuestionRepository(); // Instantiate the repository
  String? _editedName = ProfileRepo().getName();
  String? _editedDob = '';
  String? _editedCityId = '';
  String? _editedTob = '';
  bool isEditing = false;

  String? _editedName2 = '';
  String? _editedDob2 = '';
  String? _editedCityId2 = '';
  String? _editedTob2 = '';
  bool isEditing2 = false;

  Color _iconColor = Colors.black; // Initial color

//For editable dialog 1
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();
  final TextEditingController tobController = TextEditingController();

  //For editable dialog 2
  final TextEditingController name2Controller = TextEditingController();
  final TextEditingController dob2Controller = TextEditingController();
  final TextEditingController cityId2Controller = TextEditingController();
  final TextEditingController tob2Controller = TextEditingController();

  void _updateIconColor() {
    setState(() {
      _iconColor =
          _iconColor == Colors.black ? const Color(0xFFFF9933) : Colors.black;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _questionsFuture = _askQuestionRepository.fetchQuestionsByTypeId(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEditableProfileDialog2(context);
    });
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
            _profile = ProfileModel.fromJson(responseData['data']['item']);
            _compatibilityData = responseData['data']['compatibility'];
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
          _errorMessage = 'Failed to load compatibility data';
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopNavBar(
                    title: 'Specific Compatibility',
                    onLeftButtonPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompatibilityPage()),
                      );
                    },
                    onRightButtonPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupportPage()),
                      );
                    },
                    leftIcon: Icons.arrow_back, // Icon for the left side
                    rightIcon: Icons.help, // Icon for the right side
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circle and Name for Profile 1
                      Column(
                        children: [
                            CircleWithNameWidget(
                                assetPath: (_editedDob != null && _editedDob!.toString().isNotEmpty)
                                    ? 'assets/signs/default.png'
                                    : (_profile?.dob != null
                                        ? getZodiacImage(getZodiacSign(_profile!.dob.toString()))
                                        : 'assets/signs/default.png'), // Fallback image
                                name: _editedName ?? _profile?.name ?? 'no name available',
                                screenWidth: screenWidth,
                                onTap: () {
                                  if (_profile?.name != null) {
                                    _showProfileDialog(context, _profile!);
                                  } else {
                                    print("no name");
                                  }
                                },
                                primaryColor: const Color(0xFFFF9933),
                              ),
                          const SizedBox(
                              height: 8), // Space between name and 'Edit' text
                          GestureDetector(
                            onTap: () {
                              _showEditableProfileDialog(
                                  context); // Function for the first profile
                            },
                            child: const Text(
                              'Edit', // 'Edit' text below the name
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFF9933),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.1),
                      // Circle and Name for Profile 2
                      Column(
                        children: [
                          CircleWithNameWidget(
                            assetPath:  'assets/signs/default.png', // Fallback image
                            name: _person2Name!,
                            screenWidth: screenWidth,
                            onTap: () {
                              _showEditableProfileDialog2(
                                  context); // Function for the second profile
                            },
                            primaryColor: isEditing2
                                ? const Color(0xFFFF9933)
                                : const Color.fromARGB(255, 110, 110, 109),
                          ),
                          const SizedBox(
                              height: 8), // Space between name and 'Edit' text
                          GestureDetector(
                            onTap: () {
                              _showEditableProfileDialog2(
                                  context); // Function for the second profile
                            },
                            child: const Text(
                              'Edit', // 'Edit' text below the name
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFF9933),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Center(
                    child: Text(
                      'Compatibility Questions',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w100,
                        color: const Color.fromARGB(255, 87, 86, 86),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator() // Show a loading indicator while fetching data
                        : CategoryDropdown(
                            // onTap: () => null,
                            inquiryType: 'compatibility',
                            categoryTypeId: 2,
                            onQuestionsFetched: (categoryId, questions) {
                              // Handle fetched questions
                            },
                            editedProfile2:
                                isEditing2 ? getEditedProfile2() : null,
                            editedProfile:
                                isEditing ? getEditedProfile() : null,
                                  showBundleQuestions: widget.showBundleQuestions, // Pass the flag

                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          currentPageIndex: 1),
    );
  }

 void _showProfileDialog(BuildContext context, ProfileModel profile) {
  showDialog(
    context: context,
    builder: (context) {
      // Get the screen size
      final screenSize = MediaQuery.of(context).size;
      final isLargeScreen = screenSize.width > 600;

      return AlertDialog(
        title: Text(
          'User Profile',
          style: TextStyle(fontSize: isLargeScreen ? 24 : 18),
        ),
        content: SizedBox(
          width: isLargeScreen ? screenSize.width * 0.5 : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextRow('Name', profile.name, isLargeScreen),
              _buildTextRow('Date of Birth', profile.dob, isLargeScreen),
              _buildTextRow('Place of Birth', profile.cityId, isLargeScreen),
              _buildTextRow('Time of Birth', profile.tob, isLargeScreen),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(fontSize: isLargeScreen ? 18 : 14),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildTextRow(String label, String value, bool isLargeScreen) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFF9933),
          fontSize: isLargeScreen ? 20 : 16,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: TextStyle(fontSize: isLargeScreen ? 18 : 14),
      ),
      const SizedBox(height: 10),
    ],
  );
}


 void _showEditableProfileDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController(text: _editedName);
  final TextEditingController dobController = TextEditingController(text: _editedDob);
  final TextEditingController cityIdController = TextEditingController(text: _editedCityId);
  final TextEditingController tobController = TextEditingController(text: _editedTob);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Check Compatibility for:',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusting font size based on screen width
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFF9933),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', nameController, 'This field required', context),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dobController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format as yyyy-mm-dd
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildTextField('Date of Birth', dobController, 'Please select a date', context),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          tobController.text = pickedTime.format(context); // Format time
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildTextField('Time of Birth', tobController, 'Please select a time', context),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTextField('Place of Birth', cityIdController, 'This field required', context),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space buttons apart
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01, // Responsive vertical padding
                    horizontal: MediaQuery.of(context).size.width * 0.04, // Responsive horizontal padding
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 219, 35, 35),
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                isEditing = true;
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _editedName = nameController.text;
                    _editedDob = dobController.text;
                    _editedCityId = cityIdController.text;
                    _editedTob = convertTo24HourFormat(tobController.text);
                  });

                  print('Edited Name: $_editedName');
                  print('Edited Date of Birth: $_editedDob');
                  print('Edited City ID: $_editedCityId');
                  print('Edited Time of Birth: $_editedTob');

                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01, // Responsive vertical padding
                    horizontal: MediaQuery.of(context).size.width * 0.04, // Responsive horizontal padding
                  ),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
  String convertTo24HourFormat(String time12hr) {
    // Trim leading and trailing whitespaces from the input string
    time12hr = time12hr.trim();

    // Split the time string into the time and the period (AM/PM)
    List<String> parts = time12hr.split(' ');

    if (parts.length != 2) {
      return '00:00'; // Return default value in case of invalid input
    }

    String timePart = parts[0]; // e.g., "7:21"
    String period = parts[1]; // e.g., "AM" or "PM"

    // Split the timePart into hour and minute
    List<String> timeParts = timePart.split(':');
    if (timeParts.length != 2) {
      return '00:00'; // Return default value in case of invalid format
    }

    int hour = int.parse(timeParts[0]); // Get the hour
    int minute = int.parse(timeParts[1]); // Get the minute

    // Convert to 24-hour format based on AM/PM
    if (period == 'AM' || period == 'am') {
      if (hour == 12) {
        hour = 0; // Convert "12 AM" to "00:00"
      }
    } else if (period == 'PM' || period == 'pm') {
      if (hour != 12) {
        hour += 12; // Convert "1 PM" to "13", "2 PM" to "14", etc.
      }
    } else {
      return '00:00'; // Return default value if AM/PM is invalid
    }

    // Format the hour and minute to ensure two digits for hour and minute
    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');

    // Return the formatted 24-hour time
    return '$hourString:$minuteString';
  }

  Map<String, dynamic> getEditedProfile() {
    return {
      'name': _editedName,
      'dob': _editedDob,
      'city_id': _editedCityId,
      'tob': _editedTob, // Default to an empty string if null
    };
  }

   Widget _buildTextField(String label, TextEditingController controller, String validationMessage, BuildContext context) {
  // Using MediaQuery to adjust padding, font size and width dynamically
  double screenWidth = MediaQuery.of(context).size.width;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color.fromARGB(255, 87, 86, 86),
          fontSize: screenWidth * 0.03, // Dynamic font size
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(height: screenWidth * 0.02), // Adjusted space based on screen size
      SizedBox(
        width: screenWidth * 0.8, // Adjust width of text field based on screen size
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '', // Keep hint text minimal
            contentPadding: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.03), // Adjust padding dynamically
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFFF9933), width: 1),
            ),
          ),
          style: TextStyle(fontSize: screenWidth * 0.03), // Adjust font size dynamically
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }
            if (label.contains('Date of Birth') && !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
              return 'Please enter date in yyyy-mm-dd format';
            }
            return null;
          },
        ),
      ),
      SizedBox(height: screenWidth * 0.04), // Adjust space after text field
    ],
  );
  }

  void _showEditableProfileDialog2(BuildContext context) {
  final TextEditingController name2Controller = TextEditingController(text: _editedName2);
  final TextEditingController dob2Controller = TextEditingController(text: _editedDob2);
  final TextEditingController city2IdController = TextEditingController(text: _editedCityId2);
  final TextEditingController tob2Controller = TextEditingController(text: _editedTob2);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Check Compatibility with:',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.035, // Adjusting font size based on screen width
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFF9933),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', name2Controller, 'This field required', context),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dob2Controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format as yyyy-mm-dd
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildTextField('Date of Birth', dob2Controller, 'Please select a date', context),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          tob2Controller.text = pickedTime.format(context); // Format time
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildTextField('Time of Birth', tob2Controller, 'Please select a time', context),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTextField('Place of Birth', city2IdController, 'This field required', context),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space buttons apart
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01, // Responsive vertical padding
                    horizontal: MediaQuery.of(context).size.width * 0.04, // Responsive horizontal padding
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 219, 35, 35),
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                ),
              ),
            ),
            TextButton(
              onPressed: () {
              _person2Name = name2Controller.text;
              isEditing2 = true;
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _editedName2 = name2Controller.text;
                    _editedDob2 = dob2Controller.text;
                    _editedCityId2 = cityId2Controller.text;
                    _editedTob2 = convertTo24HourFormat(tob2Controller.text);
                  });

                  print('Edited Name: $_editedName2');
                  print('Edited Date of Birth: $_editedDob2');
                  print('Edited City ID: $_editedCityId2');
                  print('Edited Time of Birth: $_editedTob2');

                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01, // Responsive vertical padding
                    horizontal: MediaQuery.of(context).size.width * 0.04, // Responsive horizontal padding
                  ),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
  
  Map<String, dynamic> getEditedProfile2() {
    return {
      'name': _editedName2,
      'dob': _editedDob2,
      'city_id': _editedCityId2,
      'tob': _editedTob2, // Default to an empty string if null
    };
  }
// }
}