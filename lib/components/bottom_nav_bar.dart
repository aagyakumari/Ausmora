import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/ask_a_question/ui/ask_a_question_page.dart';
import 'package:flutter_application_1/features/auspicious_time/ui/auspicious_time_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/horoscope/ui/horoscope_page.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:flutter_application_1/features/inbox/ui/inbox_page.dart';

class BottomNavBar extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final int? currentPageIndex;

  const BottomNavBar({super.key, 
    required this.screenWidth,
    required this.screenHeight,
    this.currentPageIndex,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    fetchUnreadMessages();
  }

  Future<void> fetchUnreadMessages() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');

      if (token == null) {
        throw Exception('Token is not available');
      }

      const url = 'http://145.223.23.200:3004/frontend/GuestInquiry/TotalUnreadMessage';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['error_code'] == "0") {
          setState(() {
            unreadMessages = responseData['data']['total_unread_message'] ?? 0;
          });
        } else {
          throw Exception('Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch unread messages: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unread messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(
            context,
            index: 0,
            iconImage: 'assets/images/horoscope2.png',
            label: 'Horoscope',
            targetPage: HoroscopePage(showBundleQuestions: false,),
          ),
          _buildNavItem(
            context,
            index: 1,
            iconImage: 'assets/images/compatibility2.png',
            label: 'Compatibility',
            targetPage: CompatibilityPage(),
          ),
          _buildAskButton(context),
          _buildNavItem(
            context,
            index: 2,
            iconImage: 'assets/images/auspicious2.png',
            label: 'Auspicious',
            targetPage: AuspiciousTimePage(showBundleQuestions: false),
          ),
          _buildInboxItem(context),
        ],
      ),
    );
  }

  Widget _buildInboxItem(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InboxPage()),
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Inbox.png',
                  width: widget.screenWidth * 0.07,
                  height: widget.screenWidth * 0.07,
                  color: widget.currentPageIndex == 3
                      ? const Color(0xFFFF9933)
                      : null,
                ),
                const SizedBox(height: 2),
                Text(
                  'Inquiries',
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.currentPageIndex == 3
                        ? const Color(0xFFFF9933)
                        : Colors.black,
                    fontWeight: widget.currentPageIndex == 3
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (unreadMessages > 0)
              Positioned(
                top: 10,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$unreadMessages',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    String? iconImage,
    required String label,
    required Widget targetPage,
  }) {
    bool isSelected = widget.currentPageIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconImage!,
              width: widget.screenWidth * 0.07,
              height: widget.screenWidth * 0.07,
              color: isSelected ? const Color(0xFFFF9933) : null,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFFFF9933) : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAskButton(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AskQuestionPage()),
              );
            },
            child: Container(
              width: widget.screenWidth * 0.070,
              height: widget.screenWidth * 0.070,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF9933),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: widget.screenWidth * 0.06,
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Ask',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
