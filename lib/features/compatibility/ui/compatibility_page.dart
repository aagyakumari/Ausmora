import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/buildcirclewithname.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/components/zodiac.utils.dart';
import 'package:flutter_application_1/features/compatibility/model/compatibility_model.dart';
import 'package:flutter_application_1/features/compatibility/service/compatibility_service.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page2.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/compatibility/repo/compatibility_repo.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/profile/model/profile_model.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

  @override
  _CompatibilityPageState createState() => _CompatibilityPageState();
}

class _CompatibilityPageState extends State<CompatibilityPage> {
  late Future<Compatibility> _compatibilityFuture;
  final CompatibilityService _service =
      CompatibilityService(CompatibilityRepository());
  final Color primaryColor = const Color(0xFFFF9933);
  ProfileModel? _profile;
  Map<String, dynamic>? _compatibilityData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isExpanded = false; // State variable for text expansion

  @override
  void initState() {
    super.initState();
    _fetchProfileData();

    // Get the current date
    final today = DateTime.now();
    final formattedDate =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    _compatibilityFuture =
        _service.getCompatibility(formattedDate); // Use dynamic date if needed
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
                        title: 'Compatibility',
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
                      SizedBox(height: screenHeight * 0.04),
                      // Horoscope Description
                      FutureBuilder<Compatibility>(
                        future: _compatibilityFuture,
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
                              snapshot.data?.compatibility == null ||
                              snapshot.data!.compatibility.isEmpty) {
                            return Center(
                              child: Text(
                                'No compatibility data available at the moment.',
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
                            final compatibility = snapshot.data!;
                            final description = compatibility.compatibility;
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
                    ],
                  ),
                ),
              ),
              CustomButton(
                buttonText: 'Get Specific Compatibility',
                onPressed: () {
                  // Define your button action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompatibilityPage2(showBundleQuestions: false)),
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              currentPageIndex: 1),
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

}
