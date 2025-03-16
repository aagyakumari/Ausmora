import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/buildcirclewithname.dart';
import 'package:flutter_application_1/components/categorydropdown.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/components/zodiac.utils.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_category_model.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:flutter_application_1/features/ask_a_question/service/ask_a_question_service.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/profile/model/profile_model.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AskQuestionPage extends StatefulWidget {
  const AskQuestionPage({super.key});

  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final AskQuestionService _service = AskQuestionService();
  Map<int, List<QuestionCategory>> categoriesByType = {};
  Map<String, List<Question>> questionsByCategoryId = {};
  int? selectedTypeId;
  String? selectedQuestionId;
  bool _isLoading = true;
  ProfileModel? _profile;
  String? _errorMessage;

  Map<String, dynamic> profile = {
    "name": "Ramesh", // Default user details
    "city_id": "Birjung",
    "dob": "2024-01-01",
    "tob": "11:10",
  };

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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
            _profile = ProfileModel.fromJson(responseData['data']['item']);
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

  Future<void> _fetchCategories() async {
    try {
      final allCategories = await _service.getCategories();
      setState(() {
        categoriesByType = {};
        for (var category in allCategories) {
          if (categoriesByType[category.categoryTypeId] == null) {
            categoriesByType[category.categoryTypeId] = [];
          }
          categoriesByType[category.categoryTypeId]!.add(category);
        }
      });
    } catch (e) {
      // Handle error
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchQuestions(int typeId) async {
    try {
      final questions = await _service.getQuestionsByTypeId(typeId);
      setState(() {
        questionsByCategoryId = {};
        for (var question in questions) {
          if (questionsByCategoryId[question.questionCategoryId] == null) {
            questionsByCategoryId[question.questionCategoryId] = [];
          }
          questionsByCategoryId[question.questionCategoryId]!.add(question);
        }
      });
    } catch (e) {
      // Handle error
      print('Error fetching questions: $e');
    }
  }

  Future<void> _handleTickIconTap() async {
    if (selectedQuestionId == null) {
      print('No question selected');
      return;
    }

    try {
      final box = Hive.box('settings');
      String? token =
          await box.get('token'); // Retrieve the token from Hive storage

      const url =
          'http://145.223.23.200:3004/frontend/GuestInquiry/StartInquiryProcess'; // Use your API URL
      final body = jsonEncode({
        "inquiry_type": 0,
        "inquiry_regular": {
          "question_id": selectedQuestionId,
        },
        "profile1": profile,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Include the token in the request headers
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Handle success
        final responseData = jsonDecode(response.body);
        print('Inquiry started successfully: $responseData');
      } else {
        // Handle error
        print('Failed to start inquiry: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('An error occurred: $e');
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
                        title: 'Ask a Question',
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
                          CircleWithNameWidget(
                                assetPath: _profile?.dob != null
                                    ? getZodiacImage(getZodiacSign(_profile!.dob))
                                    : 'assets/signs/default.png', // Fallback image
                                name: _profile?.name ?? 'no name available',
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

                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator() // Show a loading indicator while fetching data
                            : CategoryDropdown(
                                // onTap: () => null,
                                inquiryType: 'ask_a_question',
                                categoryTypeId: 6,
                                onQuestionsFetched: (categoryId, questions) {
                                  // Handle fetched questions
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
              screenWidth: screenWidth, screenHeight: screenHeight),
        ));
  }

  void _showProfileDialog(BuildContext context, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextRow('Name', profile.name),
            _buildTextRow('Date of Birth', profile.dob),
            _buildTextRow('Place of Birth', profile.cityId),
            _buildTextRow('Time of Birth', profile.tob),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
        ),
        const SizedBox(height: 5),
        Text(value), // Display the profile information
        const SizedBox(height: 10),
      ],
    );
  }
}
