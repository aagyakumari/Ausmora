import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/menu/service/menu_service.dart';
import 'package:flutter_application_1/features/settings/ui/settings_page.dart';
import 'package:flutter_application_1/features/sign_up/ui/w1_page.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'package:flutter_application_1/hive/hive_service.dart';

class Menu extends StatefulWidget {
  final VoidCallback? closeMenu;

  const Menu({super.key, this.closeMenu});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double menuWidth = size.width * 0.8;

    return SlideTransition(
      position: _offsetAnimation,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/menu.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: menuWidth,
                height: size.height,
                color: Colors.transparent,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'myFutureTime',
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inter',
                        color: const Color.fromARGB(255, 252, 127, 1),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Center(
                      child: Image.asset(
                        'assets/images/logonaya.png',
                        height: size.height * 0.1,
                        color: const Color.fromARGB(255, 252, 127, 1),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildMenuItem(context, 'My Profile', Icons.person, () {
                              MenuService.navigateToProfile(context);
                            }),
                            _buildMenuItem(context, 'Horoscope', Icons.stars, () {
                              MenuService.navigateToHoroscope(context);
                            }),
                            _buildMenuItem(context, 'Auspicious Time', Icons.access_time, () {
                              MenuService.navigateToAuspiciousTime(context);
                            }),
                            _buildMenuItem(context, 'Compatibility', Icons.favorite, () {
                              MenuService.navigateToCompatibility(context);
                            }),
                            _buildMenuItem(context, 'Our Astrologers', Icons.group, () {
                              MenuService.navigateToAstrologers(context);
                            }),
                            _buildMenuItem(context, 'Settings', Icons.settings, () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: size.height * 0.75,
                                    child: SettingsPage(),
                                  );
                                },
                              );
                            }),
                            _buildMenuItem(context, 'Contact Us', Icons.contact_mail, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportPage()));
                            }),
                            _buildMenuItem(context, 'About Us', Icons.info, () {
                              MenuService.navigateToAboutUs(context);
                            }),
                            _buildMenuItem(context, 'Log out', Icons.logout, () {
                              _showLogoutDialog(context);
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String text, IconData icon, Function onTap) {
    final size = MediaQuery.of(context).size;
    final double lineWidth = size.width * 0.7;

    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.height * 0.06),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 252, 127, 1),
                      fontSize: size.width * 0.045,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: const Color.fromARGB(255, 252, 127, 1),
                  size: size.width * 0.06,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: lineWidth,
          height: 1,
          color: const Color.fromARGB(255, 252, 127, 1),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
  final size = MediaQuery.of(context).size;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5,
        child: Container(
          width: size.width * 0.8, // Dialog width
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // "Are you sure you want to log out?" text in a single line with smaller font size
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: size.width * 0.04, // Smaller font size
                  fontWeight: FontWeight.w400, // Regular weight for minimalism
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // "Cancel" button in grey
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey, // Grey color for Cancel button
                        fontSize: size.width * 0.04, // Scaled font size
                        fontWeight: FontWeight.w600, // Slightly bold for emphasis
                      ),
                    ),
                  ),
                  // "Log out" button in red
                  TextButton(
                    onPressed: () {
                      HiveService().clearToken();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => W1Page()),
                      );
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.red, // Red color for Log out button
                        fontSize: size.width * 0.04, // Scaled font size
                        fontWeight: FontWeight.w600, // Slightly bold for emphasis
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
