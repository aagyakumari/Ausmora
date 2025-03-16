import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/features/auspicious_time/ui/auspicious_time_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboard_model.dart';
import 'package:flutter_application_1/features/dashboard/service/dashboard_service.dart';
import 'package:flutter_application_1/features/horoscope/ui/horoscope_page.dart';
import 'package:flutter_application_1/features/menu/ui/menu_page.dart';
import 'package:flutter_application_1/features/offer/model/offer_model.dart';
import 'package:flutter_application_1/features/offer/service/offer_service.dart';
import 'package:flutter_application_1/features/offer/ui/alloffers.dart';
import 'package:flutter_application_1/features/offer/ui/offer_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';

class DashboardPage extends StatefulWidget {
  final String? successMessage;

  const DashboardPage({super.key, this.successMessage});
  @override
  _DashboardState createState() => _DashboardState();
 
}

class _DashboardState extends State<DashboardPage> {
  bool _isMenuOpen = false;
  late Future<DashboardData> _dashboardDataFuture;
  late Future<List<Offer>> _offersFuture;
  bool _isConnected = true; // Track connection status
  final Connectivity _connectivity = Connectivity(); // Connectivity instance
  final bool _showOffers = true; // Toggle this to switch between offers and image.
  

  @override
  void initState() {
    super.initState();

    _checkInternetConnection(); // Check the initial connection status

    // // Listen for network changes
    // _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    //   _checkInternetConnection();
    // });

    // Get the current date
    final today = DateTime.now();
    final formattedDate =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Fetch dashboard data for the current date
    _dashboardDataFuture = DashboardService().getDashboardData(formattedDate);
    _offersFuture = OfferService().getTopOffers(); // Fetch offers data
  }

  // Method to check the internet connection
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    bool isConnected = connectivityResult != ConnectivityResult.none;

    setState(() {
      _isConnected = isConnected;
    });
  }

  void _openMenu() {
    setState(() {
      _isMenuOpen = true;
    });
  }

  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    final size = MediaQuery.of(context).size;
    final double circleSize = size.width * 0.22;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
         // Show the success message SnackBar if provided
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.successMessage!),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  });
    

    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: Colors.white,
      // bottomNavigationBar:
      //     BottomNavBar(screenWidth: screenWidth, screenHeight: screenHeight),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_isMenuOpen) {
                _closeMenu();
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -6 && _isMenuOpen) {
                _closeMenu();
              } else if (details.delta.dx > 6 && !_isMenuOpen) {
                _openMenu();
              }
            },
            child: Column(
              children: [
                TopNavBar(
                  title: 'myTime',
                  onLeftButtonPressed: () {
                    _openMenu();
                  },
                  onRightButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SupportPage()),
                    );
                  },
                  leftIcon: Icons.menu, // Icon for the left side
                  rightIcon: Icons.help, // Icon for the right side
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Offers Section or Placeholder Image
                        _showOffers
                            ? FutureBuilder<List<Offer>>(
                                future: _offersFuture,
                                builder: (context, snapshot) {
                                  if (!_isConnected) {
                                    return _noInternetContainer(size, isTablet);
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Something went wrong while fetching offers. Please try again later.',
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          fontFamily: 'Inter',
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    final offers = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: isTablet
                                              ? size.height * 0.38
                                              : size.height * 0.31,
                                          child: PageView.builder(
                                            itemCount: offers.length,
                                            itemBuilder: (context, index) {
                                              final offer = offers[index];
                                              return OfferWidget(offer: offer);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllOffersPage()),
                                              );
                                            },
                                            child: Text(
                                              'See More...',
                                              style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                fontFamily: 'Inter',
                                                color: const Color(0xFFFF9933),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      height: isTablet
                                          ? size.height * 0.38
                                          : size.height * 0.31,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFFF9933),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'No bundles available at the moment',
                                          style: TextStyle(
                                            fontSize: size.width * 0.03,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFF9933),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : Center(
                                child: Container(
                                  height: isTablet
                                      ? size.height * 0.19
                                      : size.height * 0.19,
                                  width: isTablet
                                      ? size.height * 0.19
                                      : size.height * 0.19,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/logonaya.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                       
                        SizedBox(height: size.height * 0.1),

                        // Dashboard Data Section
                        FutureBuilder<DashboardData>(
                          future: _dashboardDataFuture,
                          builder: (context, snapshot) {
                            if (!_isConnected) {
                              // Show this if no internet connection
                              return _noInternetDashboard(size);
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(
                                children: [
                                  SizedBox(height: size.height * 0.2),
                                  const Center(child: CircularProgressIndicator()),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              // Catch error and display a user-friendly message
                              return Column(children: [
                                SizedBox(height: size.height * 0.2),
                                Center(
                                  child: Text(
                                    'No data available at the moment..',
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      fontFamily: 'Inter',
                                      color: Colors.red,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ]);
                            } else if (snapshot.hasData) {
                              final data = snapshot.data!;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildCircleSection(
                                      context,
                                      title: 'Horoscope',
                                      imageUrl: 'assets/images/horoscope2.png',
                                      imageWidth: circleSize * 7,
                                      imageHeight: circleSize * 7,
                                      page: HoroscopePage(showBundleQuestions: false,),
                                      description: data.horoscope.description,
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    _buildCircleSection(
                                      context,
                                      title: 'Compatibility',
                                      imageUrl:
                                          'assets/images/compatibility2.png',
                                      imageWidth: circleSize * 0.1,
                                      imageHeight: circleSize * 0.8,
                                      page: CompatibilityPage(),
                                      compatibility: data.compatibility,
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    _buildCircleSection(
                                      context,
                                      title: 'Auspicious Time',
                                      imageUrl: 'assets/images/auspicious2.png',
                                      imageWidth: circleSize * 0.70,
                                      imageHeight: circleSize * 0.8,
                                      page: AuspiciousTimePage(showBundleQuestions: false),
                                      description: data.auspicious.description,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Center(
                                  child:
                                      Text('No data available at the moment.'));
                            }
                          },
                        ),

                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isMenuOpen ? 0 : -size.width * 0.8,
            top: 0,
            bottom: 0,
            child: Menu(),
          ),
        ],
      ),
       bottomNavigationBar:
          BottomNavBar(screenWidth: screenWidth, screenHeight: screenHeight),
    );
  }

  // Widget for no internet connection in offers section
  Widget _noInternetContainer(Size size, bool isTablet) {
    return Container(
      height: isTablet ? size.height * 0.38 : size.height * 0.31,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFFF9933),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No internet connection',
          style: TextStyle(
            fontSize: size.width * 0.03,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF9933),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Widget for no internet connection in dashboard section
  Widget _noInternetDashboard(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.wifi_off,
            size: 50,
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          Text(
            'No internet connection. Please check your connection.',
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleSection(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required double imageWidth,
    required double imageHeight,
    required Widget page,
    String? compatibility,
    String? description,
  }) {
    final size = MediaQuery.of(context).size;
    final double circleSize = size.width * 0.18;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF9933)),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(imageUrl,
                      width: imageWidth, height: imageHeight),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in #FF9933
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF9933), // Title color set to #FF9933
                      ),
                    ),
                    if (description != null)
                      // Rating in black
                      Text(
                        description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                          fontFamily: 'Inter',
                          color:
                              Colors.black, // Black for compatibility details
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 3, // Allow text to wrap
                      ),
                    if (compatibility != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          // Compatibility data in black
                          Text(
                            compatibility,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: size.width * 0.03,
                              fontFamily: 'Inter',
                              color: Colors
                                  .black, // Black for compatibility details
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 3, // Allow text to wrap
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
