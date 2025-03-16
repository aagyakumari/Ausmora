import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:flutter_application_1/features/menu/ui/menu_page.dart';

class MainLogoPage extends StatefulWidget {
  const MainLogoPage({super.key});

  @override
  _MainLogoPageState createState() => _MainLogoPageState();
}

class _MainLogoPageState extends State<MainLogoPage> {
  bool _isMenuOpen = false; // Track menu visibility
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openMenu() {
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = MediaQuery.of(context).size.width > 600;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_isMenuOpen) {
                _closeMenu();
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -6 && _isMenuOpen) {
                _closeMenu();
              } else if (details.delta.dx > 6 && !_isMenuOpen) {
                _openMenu();
              }
            },
            child: Column(
              children: [
                TopNavBar(
                  title: 'myTime',
                  leftIcon: Icons.menu,
                  rightIcon: Icons.help,
                  onLeftButtonPressed: _openMenu,
                  onRightButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SupportPage()),
                    );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: Container(
                            height: isTablet
                                ? size.height * 0.19
                                : size.height * 0.19,
                            width: isTablet
                                ? size.height * 0.19
                                : size.height * 0.19,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/logonaya.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                          child: Text(
                            'Thank You for Your Details!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Inter',
                              color: const Color(0xFFFF9933),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                          child: Text(
                            'Please hold on while our astrology gurus work on crafting your personalized birth-chart. '
                            'This process takes approximately 1-2 hours to ensure accuracy and proper depth.\n\n'
                            'A well-curated birth-chart can help us figure out almost everything for you!',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: screenWidth * 0.040,
                              fontFamily: 'Inter',
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                          child: Text(
                            'We\'ll update you as soon as birth charts are ready.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontFamily: 'Inter',
                              color: const Color(0xFFFF9933),
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sliding Menu
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isMenuOpen ? 0 : -screenWidth * 0.8,
            top: 0,
            bottom: 0,
            child: Menu(),
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNavBar(screenWidth: screenWidth, screenHeight: screenHeight),
    );
  }
}
