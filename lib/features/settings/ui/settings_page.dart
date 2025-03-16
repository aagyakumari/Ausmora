import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/settings/widgets/settings_tile.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 32, 47),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFCF9D66), Color(0x1E695034)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: const Color(0xFF1F1101),
                        fontSize: screenWidth * 0.04,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SettingsTile(
                  imagePath: "assets/images/Group 10.png",
                  title: 'Customer Support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SupportPage()),
                    );
                  },
                ),
                SettingsTile(
                  imagePath: "assets/images/policies.png",
                  title: 'Terms & Privacy',
                  onTap: () {
                    // Handle terms and privacy action
                  },
                ),
                SettingsTile(
                  title: 'Appearance',
                  onTap: () {
                    // Handle appearance action
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildThemeOptions(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOptions(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildThemeOption(
            screenWidth,
            screenHeight,
            'Light',
            'assets/images/Checkbox Circle.png',
            const Color(0xFFCF9D66),
            Colors.white,
          ),
          _buildThemeOption(
            screenWidth,
            screenHeight,
            'Dark',
            'assets/images/Circle (1).png',
            const Color(0xFFF4DFC8),
            const Color(0xFF282727),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
      double screenWidth,
      double screenHeight,
      String label,
      String imagePath,
      Color borderColor,
      Color backgroundColor) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: screenWidth * 0.2,
              height: screenHeight * 0.2,
              decoration: ShapeDecoration(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.02,
              top: screenHeight * 0.01,
              child: Container(
                width: screenWidth * 0.16,
                height: screenHeight * 0.02,
                decoration: ShapeDecoration(
                  color: borderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF110606),
                fontSize: screenWidth * 0.04,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Image.asset(
              imagePath,
              width: screenWidth * 0.1,
              height: screenHeight * 0.03,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}
