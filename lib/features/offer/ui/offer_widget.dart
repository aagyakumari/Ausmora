import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auspicious_time/ui/auspicious_time_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page2.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/horoscope/ui/horoscope_page.dart';
import 'package:flutter_application_1/features/offer/model/offer_model.dart';
import 'package:flutter_application_1/features/offer/repo/offer_repo.dart';
import 'package:flutter_application_1/features/offer/ui/offer_page.dart';

class OfferWidget extends StatefulWidget {
  final Offer? offer; // Nullable offer
  final bool tappable; // Control tap behavior

  const OfferWidget({super.key, this.offer, this.tappable = true}); // Default to true

  @override
  _OfferWidgetState createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (widget.offer == null) {
      return _buildNoBundleContainer(screenWidth, screenHeight);
    }

   return widget.tappable
    ? GestureDetector(
        onTap: () {
          if (widget.offer == null) return;

          Widget destinationPage;
          switch (widget.offer!.categoryTypeId) { // Use categoryTypeId instead
            case 1:
              destinationPage = HoroscopePage(showBundleQuestions: true);
              break;
            case 2:
              destinationPage = CompatibilityPage2(showBundleQuestions:true);
              break;
            case 3:
              destinationPage = AuspiciousTimePage(showBundleQuestions:true);
              break;
            default:
              destinationPage = DashboardPage();
              break;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        child: _buildOfferContainer(screenWidth, screenHeight),
      )
    : _buildOfferContainer(screenWidth, screenHeight);
    }

  

  Widget _buildNoBundleContainer(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        border: Border.all(
          color: const Color(0xFFFF9933), // Orange border
          width: 2.0, // Set border width
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          'No bundles available at the moment',
          style: TextStyle(
            fontSize: screenWidth * 0.05, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildOfferContainer(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        border: Border.all(
          color: const Color(0xFFFF9933), // Orange border
          width: 2.0, // Set border width
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.offer?.question ?? 'No Question Available',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Show the price and possibly the original price before discount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${widget.offer?.price.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.green,
                    ),
                  ),
                  if (widget.offer?.priceBeforeDiscount != null)
                    Text(
                      '\$${widget.offer?.priceBeforeDiscount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          // Image container for question image (assuming image is related to the offer)
          widget.offer?.imageData != null
              ? Image.memory(
                  widget.offer!.imageData!,
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.14,
                  fit: BoxFit.cover,
                )
              : Placeholder(
                  fallbackHeight: screenHeight * 0.14,
                  fallbackWidth: screenWidth * 0.9,
                ),
          SizedBox(height: screenHeight * 0.01),
          // Remove Auspicious Question, it's not required anymore
        ],
      ),
    );
  }
}
