import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/custom_button.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/features/support/ui/support_submit.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    String feedback = _feedbackController.text;
    // Submit feedback logic here
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SupportSubmit(feedback: feedback)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Wrapping the body content in a SingleChildScrollView
        child: Column(
          children: [
            TopNavBar(
              title: 'Support',
              onLeftButtonPressed: () {
                Navigator.pop(context); // Back to previous page
              },
              onRightButtonPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
              leftIcon: Icons.arrow_back, // Back button icon
              rightIcon: Icons.help, // Inbox button icon
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: Image.asset(
                'assets/images/support.png',
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: TextField(
                controller: _feedbackController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter your feedback or issues here...',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.15),
            CustomButton(
              buttonText: 'Submit',
              onPressed: _handleSubmit,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(screenWidth: screenWidth, screenHeight: screenHeight),
    );
  }
}
