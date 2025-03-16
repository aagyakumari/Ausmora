import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/inbox/ui/inbox_page.dart';

class ProfileHeader extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ProfileHeader({super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.normal,
                fontFamily: 'Inter',
                color: const Color(0xFFFF9933),
              ),
            ),
          ),
          Text(
            'My profile',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.normal,
              fontFamily: 'Inter',
              color: const Color(0xFFFF9933),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InboxPage()), // Navigate to InboxPage
              );
            },
            child: Container(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFF9933)),
                borderRadius: BorderRadius.circular(
                    screenWidth * 0.06), // Matching radius
              ),
              child: const Icon(Icons.inbox, color: Color(0xFFFF9933)),
            ),
          ),
        ],
      ),
    );
  }
}
