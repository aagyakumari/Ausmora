import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final String title;
  final VoidCallback? onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
   final IconData? leftIcon; // Optional left icon
  final IconData rightIcon;

  const TopNavBar({super.key, 
    required this.title,
    this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    this.leftIcon = Icons.menu, // Default left icon is menu
    this.rightIcon = Icons.done, // Default right icon is done
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double iconSize = size.width * 0.08; // Reduced icon size
    final double titleFontSize = size.width * 0.05; // Reduced font size

    return SafeArea(
      top: true, // Ensure content respects the top system UI
      child: Padding(
        padding: const EdgeInsets.only(
            left: 12, right: 12, top: 4, bottom: 6), // Adjusted padding
        child: SizedBox(
          width: double.infinity, // Ensure it takes up full width
          child: Stack(
            children: [
              // Center the title
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight:
                        FontWeight.w500, // Semi-bold for better visibility
                    fontFamily: 'Inter',
                    color: const Color.fromARGB(255, 87, 86, 86),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Align the left icon
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap:
                      onLeftButtonPressed, // Call the action on left button press
                  child: Icon(
                    leftIcon,
                    color: const Color.fromARGB(255, 87, 86, 86),
                    size: iconSize,
                  ),
                ),
              ),
              // Align the right icon
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap:
                      onRightButtonPressed, // Call the action on right button press
                  child: Icon(
                    rightIcon,
                    color: const Color.fromARGB(255, 87, 86, 86),
                    size: iconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
