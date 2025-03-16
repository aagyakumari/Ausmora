// lib/features/our_astrologers/ui/our_astrologers_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/features/astrologers/model/astrologer_model.dart';
import 'package:flutter_application_1/features/astrologers/repo/astrologer_repo.dart';
import 'package:flutter_application_1/features/astrologers/service/astrologer_service.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:hive/hive.dart';

class OurAstrologersPage extends StatefulWidget {
  const OurAstrologersPage({super.key});

  @override
  _OurAstrologersPageState createState() => _OurAstrologersPageState();
}

class _OurAstrologersPageState extends State<OurAstrologersPage> {
  final AstrologerService _astrologerService =
      AstrologerService(AstrologerRepository());
  late Future<List<Astrologer>> _astrologersFuture;

  @override
  void initState() {
    super.initState();
    _astrologersFuture = _astrologerService.getAstrologers();
  }

  @override
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
                        title: 'Astrologers',
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

                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Image.asset(
                          'assets/images/astrologer.png', // Replace with your actual image asset path
                          width: screenWidth *
                              0.9, // Adjust width and height based on screen width
                          height: screenWidth * 0.7,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.02),
                      // FutureBuilder<List<Astrologer>>(
                      //   future: _astrologersFuture,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return Center(child: CircularProgressIndicator());
                      //     } else if (snapshot.hasError) {
                      //       return Center(child: Text('Error: ${snapshot.error}'));
                      //     } else if (snapshot.hasData) {
                      //       return Column(
                      //         children: snapshot.data!.map((astrologer) {
                      //           return Card(
                      //             child: ListTile(
                      //               leading: Image.asset(astrologer.imageUrl, width: 50, height: 50),
                      //               title: Text(astrologer.name),
                      //               subtitle: Text(astrologer.specialization),
                      //             ),
                      //           );
                      //         }).toList(),
                      //       );
                      //     } else {
                      //       return Center(child: Text('No Astrologers found.'));
                      //     }
                      //   },
                      // ),
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
}
