import 'package:flutter/material.dart';

class LuckyInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double screenWidth;
  final double screenHeight;

  const LuckyInfoCard({super.key, 
    required this.title,
    required this.value,
    required this.icon,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.25,
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9933),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: screenWidth * 0.1),
          SizedBox(height: screenHeight * 0.01),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.04,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.04,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
