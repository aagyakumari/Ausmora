import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;

  const SettingsTile({super.key, 
    required this.title,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ListTile(
          leading: imagePath != null
              ? Image.asset(
                  imagePath!,
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.075,
                  fit: BoxFit.contain,
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1F1101),
              fontSize: screenWidth * 0.04,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          onTap: onTap,
        ),
        const Divider(color: Color(0xFF1F1101)),
      ],
    );
  }
}