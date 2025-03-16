import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/profile/ui/lucky_info_card.dart';

class LuckyInfoSection extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const LuckyInfoSection({super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: screenWidth * 0.9,
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFFF4DFC8).withOpacity(0.7),
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 6,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'WHO YOU ARE?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFC06500),
                fontSize: screenWidth * 0.04,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LuckyInfoCard(
                  title: 'Lucky Color',
                  value: 'Orange',
                  icon: Icons.color_lens,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(width: screenWidth * 0.02),
                LuckyInfoCard(
                  title: 'Lucky Number',
                  value: '5',
                  icon: Icons.casino,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SizedBox(width: screenWidth * 0.02),
                LuckyInfoCard(
                  title: 'Lucky Day',
                  value: 'Wednesday',
                  icon: Icons.calendar_today,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
