import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double screenWidth;
  final double screenHeight;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: screenHeight * 0.01),
            FractionallySizedBox(  // This makes the button width responsive
              alignment: Alignment.center,
              widthFactor: 0.6,  // Adjusts the button's width to be 60% of the screen width
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9933),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  fixedSize: Size(double.infinity, screenHeight * 0.07), // Height is responsive based on screenHeight
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
