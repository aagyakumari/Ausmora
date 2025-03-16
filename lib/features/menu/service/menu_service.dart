import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/astrologers/ui/astrologer_page.dart';
import 'package:flutter_application_1/features/auspicious_time/ui/auspicious_time_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/horoscope/ui/horoscope_page.dart';
import 'package:flutter_application_1/features/profile/ui/profile_details.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';

class MenuService {
  static void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileDetails()),
    );
  }

  static void navigateToHoroscope(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HoroscopePage(showBundleQuestions: false)),
    );
  }

  static void navigateToAuspiciousTime(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuspiciousTimePage(showBundleQuestions: false)),
    );
  }

  static void navigateToCompatibility(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompatibilityPage()),
    );
  }

  static void navigateToAstrologers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OurAstrologersPage()),
    );
  }

  static void navigateToContactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SupportPage()),
    );
  }

  static void navigateToAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SupportPage()),
    );
  }
}