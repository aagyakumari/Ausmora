import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/service/dashboard_service.dart';

class DashboardViewModel {
  final DashboardService _service = DashboardService();
  late PageController pageController;
  int currentPage = 0;
  bool isMenuOpen = false;
  List<String> offerImages = [];

  double get iconSize => 32.0; // Adjust as needed
  double get carouselHeight => 200.0; // Adjust as needed
  double get circleImageWidth => 50.0; // Adjust as needed
  double get circleImageHeight => 50.0; // Adjust as needed
  double get buttonWidth => 200.0; // Adjust as needed
  double get buttonHeight => 50.0; // Adjust as needed
  double get buttonFontSize => 16.0; // Adjust as needed
  double get titleFontSize => 20.0; // Adjust as needed

  void init() async {
    offerImages = await _service.getOfferImages();
    pageController = PageController(initialPage: currentPage);
  }

  void dispose() {
    pageController.dispose();
  }

  void openMenu() {
    isMenuOpen = true;
  }

  void closeMenu() {
    isMenuOpen = false;
  }
}
class Offer {
  final String imageUrl;

  Offer({required this.imageUrl});
}