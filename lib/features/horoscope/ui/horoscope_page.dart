import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/buildcirclewithname.dart';
import 'package:flutter_application_1/components/categorydropdown.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/components/zodiac.utils.dart';
import 'package:flutter_application_1/features/ask_a_question/repo/ask_a_question_repo.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/horoscope/model/horoscope_model.dart';
import 'package:flutter_application_1/features/horoscope/service/horoscope_service.dart';
import 'package:flutter_application_1/features/horoscope/repo/horoscope_repo.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart'; // Import the question model
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/profile/model/profile_model.dart';
import 'package:flutter_application_1/features/profile/repo/profile_repo.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class HoroscopePage extends StatefulWidget {
  final bool showBundleQuestions;
  const HoroscopePage({super.key, required this.showBundleQuestions});
  

  @override
  _HoroscopePageState createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  final Color primaryColor = const Color(0xFFFF9933);

  late Future<Horoscope> _horoscopeFuture;
  late Future<List<Question>>
      _questionsFuture; // Future for Horoscope questions
  final HoroscopeService _service = HoroscopeService(HoroscopeRepository());
  final AskQuestionRepository _askQuestionRepository =
      AskQuestionRepository(); // Instantiate the repository
  bool _isExpanded = false; // State variable for text expansion
  ProfileModel? _profile;
  Map<String, dynamic>? _horoscopeData;
  final String? _person2Name = 'Person 2'; // Variable to store Person 2's name

  bool _isLoading = true;
  String? _errorMessage;
  // Add a DateTime variable to store the selected date
  DateTime? _selectedDate;
  DateTime? _horoscopeSelectedDate;

  String? _editedName = ProfileRepo().getName();
  String? _editedDob = '';
  String? _editedCityId = '';
  String? _editedTob = '';
  bool isEditing = false;

  Color _iconColor = Colors.black; // Initial color

  void _updateIconColor() {
    setState(() {
      _iconColor =
          _iconColor == Colors.black ? const Color(0xFFFF9933) : Colors.black;
    });
  }

  // Method to show DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _horoscopeSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFFF9933), // Customize the picker color
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _horoscopeSelectedDate) {
      setState(() {
        _horoscopeSelectedDate = picked;
      });
    }
  }

  void _showDateSelectionMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a date before proceeding.'),
        backgroundColor: Colors.red,
      ),
    );
  }

//For editable dialog 1
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();
  final TextEditingController tobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Set the default date to the current date
    _fetchProfileData();
    _horoscopeFuture = _service.getHoroscope(_selectedDate!
        .toString()
        .split(' ')[0]); // Initialize with the current date
    _questionsFuture = _askQuestionRepository.fetchQuestionsByTypeId(1);
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
            _horoscopeData = responseData['data']['horoscope'];
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
          _errorMessage = 'Failed to load horoscope data';
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

    return WillPopScope(
          onWillPop: () async {
      final box = Hive.box('settings');
      final guestProfile = await box.get('guest_profile');
      
      if (guestProfile != null) {
        // Navigate to DashboardPage if guest_profile is not null
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        // Navigate to MainLogoPage if guest_profile is null
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLogoPage()),
        );
      }
      
      return false; // Prevent the default back button behavior
    },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: screenHeight *
                          0.4), // Increased bottom padding to accommodate questions
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Using TopNavWidget instead of SafeArea with custom AppBar
                      // Use TopNavBar here with correct arguments
                      TopNavBar(
                        title: 'Horoscope',
                          onLeftButtonPressed: () async {
                            final box = Hive.box('settings');
                            final guestProfile = await box.get('guest_profile');

                            if (guestProfile != null) {
                              // Navigate to DashboardPage if guest_profile is not null
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => DashboardPage()),
                              );
                            } else {
                              // Navigate to MainLogoPage if guest_profile is null
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainLogoPage()),
                              );
                            }
                          },
                        onRightButtonPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SupportPage()),
                          );
                        },
                        leftIcon: Icons.arrow_back, // Icon for the left side
                        rightIcon: Icons.help, // Icon for the right side
                      ),

                      SizedBox(height: screenHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              SizedBox(
                                  height: screenHeight *
                                      0.01), // Space between name and edit text
                              GestureDetector(
                                onTap: () {
                                  _showEditableProfileDialog(context);
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: const Color(0xFFFF9933),
                                    fontSize: screenWidth * 0.035,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),
                      // Horoscope Description
                      FutureBuilder<Horoscope>(
                        future: _horoscopeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Data is being generated, please wait....',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.040,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w100,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data?.description == null ||
                              snapshot.data!.description.isEmpty) {
                            return Center(
                              child: Text(
                                'No horoscope data available at the moment.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.040,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w100,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else {
                            final horoscope = snapshot.data!;
                            final description = horoscope.description;
                            final maxLines = _isExpanded
                                ? null
                                : 3; // Show full text if expanded, else limit to 3 lines

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    description,
                                    maxLines: maxLines,
                                    overflow: _isExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.040,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isExpanded =
                                            !_isExpanded; // Toggle text expansion
                                      });
                                    },
                                    child: Text(
                                      _isExpanded
                                          ? 'View Less'
                                          : 'View More', // Change button text based on state
                                      style: TextStyle(
                                        color: const Color(0xFFFF9933),
                                        fontSize: screenWidth * 0.03,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Text(
                          'Horoscope Questions',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w100,
                            color: const Color.fromARGB(255, 87, 86, 86),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),
                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator() // Show a loading indicator while fetching data
                            : CategoryDropdown(
                                //  onTap: () => _selectDate(context),
                                inquiryType: 'Horoscope',
                                categoryTypeId: 1,
                                //  horoscopeFromDate: _horoscopeSelectedDate != null
                                //   ? formattedDate
                                //   : 'Please select a date', // Fallback message for unselected date
                                onQuestionsFetched: (categoryId, questions) {
                                  if (_horoscopeSelectedDate == null) {
                                    _showDateSelectionMessage();
                                  } else {
                                    // Handle fetched questions
                                  }
                                },
                                editedProfile:
                                    isEditing ? getEditedProfile() : null,
                                      showBundleQuestions: widget.showBundleQuestions, // Pass the flag

                              ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              currentPageIndex: 0),
        ));
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
        'Check Horoscope for:',
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
}