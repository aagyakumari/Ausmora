import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/payment/service/payment_service.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';

class PaymentPage extends StatelessWidget {
  final PaymentService _paymentService = PaymentService();
  final Function
      _handleTickIconTap; // Function to handle payment option selection
  final String question; // The question the user is buying
  final double price; // The price of the selected question
  final String inquiryType;

  PaymentPage({super.key, 
    required Function handleTickIconTap,
    required this.question,
    required this.price,
    required this.inquiryType,
  }) : _handleTickIconTap = handleTickIconTap;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final paymentOptions =
        _paymentService.fetchPaymentOptions(() => _handleTickIconTap());

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
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
                    // Top Navigation Bar
                    TopNavBar(
                      title: 'Payment',
                      onLeftButtonPressed: () {
                        Navigator.pop(context);
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
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: Column(
                        children: [
                          // Payment Icon Container
                          Container(
                            width: screenWidth * 0.3,
                            height: screenWidth * 0.3,
                            decoration: const ShapeDecoration(
                              color: Colors.transparent,
                              shape: CircleBorder(
                                side: BorderSide(
                                    width: 2, color: Color(0xFFFF9933)),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/payment.png',
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.15,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Payment Info Container
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.015),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Text(
                                'You will only be charged \$${price.toStringAsFixed(2)} for "$question" of $inquiryType category.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth *
                                      0.02, // Smaller font for elegant look
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          // Payment Options
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: paymentOptions.map((option) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _handleTickIconTap();
                                    },
                                    child: Image.asset(
                                      option.imagePath,
                                      width: screenWidth * 0.2,
                                      height: screenWidth * 0.2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            BottomNavBar(screenWidth: screenWidth, screenHeight: screenHeight),
      ),
    );
  }
}
