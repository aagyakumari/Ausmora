import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CelestialBackgroundPainter.dart';
import 'package:flutter_application_1/components/animated_text.dart';
import 'package:flutter_application_1/features/sign_up/model/user_model.dart';
import 'package:flutter_application_1/features/sign_up/repo/sign_up_repo.dart';
import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
import '../../otp/ui/otp.dart';

class W1Page extends StatefulWidget {
  const W1Page({super.key});

  @override
  _W1PageState createState() => _W1PageState();
}

class _W1PageState extends State<W1Page> with TickerProviderStateMixin {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final SignUpRepo _signUpRepo = SignUpRepo();
  final HiveService _hiveService = HiveService();

  bool _isLoginMode = false;
  bool _isLoading = false;
  
  // late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _videoController.dispose();  // Always dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/w1_tablet.png', // Add your background image on top
              fit: BoxFit.cover,
            ),
          ),

          // Positioned(
          //   top:
          //       0, // Set this to 0 so the container starts at the top of the screen
          //   left: 0,
          //   right: 0,
          //   child: Opacity(
          //     opacity: 0.5, // Adjust the opacity of the GIF here (0.0 to 1.0)
          //     child: SizedBox(
          //       height:
          //           MediaQuery.of(context).size.height, // 30% of screen heightP
          //       width: MediaQuery.of(context).size.width, // Full screen width
          //       child: Transform(
          //         alignment: Alignment.center,
          //         transform: Matrix4.rotationX(
          //             3.14159), // Upside down flip using rotation along the X-axis
          //         child: Image.asset(
          //           'assets/images/finalfog.gif', // Use the GIF here as the background
          //           fit: BoxFit.cover, // Ensures the GIF covers the container
          //           repeat: ImageRepeat.noRepeat, // Default GIF loop
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Positioned.fill(
            child: CelestialBackground(),
          ),
          // NebulaBackground(),

          // Foreground Content

         // Logo without rotation animation
Positioned(
  top: 0,
  left: 0,
  right: 0,
  height: isTablet
      ? MediaQuery.of(context).size.height * 0.4 // Adjust height for tablets
      : MediaQuery.of(context).size.height * 0.45, // Adjust height for phones
  child: Center(
    child: FractionallySizedBox(
      widthFactor: isTablet ? 1 : 0.6, // Different width for tablet/phone
      heightFactor: isTablet ? 1 : 0.6, // Different height for tablet/phone
      child: Image.asset(
        'assets/images/frame5_tablet.png',
        fit: BoxFit.contain, // Use 'contain' for better scaling
      ),
    ),
  ),
),

// AnimatedTextWidget for displaying text
Positioned(
  bottom: isTablet
      ? MediaQuery.of(context).size.height * 0.55 // Adjust bottom spacing for tablets
      : MediaQuery.of(context).size.height * 0.6, // Adjust bottom spacing for phones
  left: 0,
  right: 0,
  child: AnimatedTextWidget(
    texts: const [
      "love",
      "career",
      "friendship",
      "business",
      "education",
      "partnership",
      "marriage"
    ],
    textStyle: TextStyle(
      fontSize: isTablet
          ? MediaQuery.of(context).size.height * 0.025 // Slightly larger font size for tablets
          : MediaQuery.of(context).size.height * 0.02, // Font size for phones
      color: Colors.orange,
      fontWeight: FontWeight.w200,
      fontFamily: 'Inter',
    ),
  ),
),


          // Form section
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 50.0 : 16.0,
                vertical: isTablet ? 30.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isTablet)
                    SizedBox(height: MediaQuery.of(context).size.height * 0.4)
                  else
                    SizedBox(height: MediaQuery.of(context).size.height * 0.45),
                  SizedBox(height: isTablet ? 18 : 8),
                  if (!_isLoginMode) ...[
                    _buildTextField(
                      controller: _nameController,
                      label: 'I am',
                      hintText: 'Name',
                    ),
                    SizedBox(height: isTablet ? 18 : 8),
                    _buildTextField(
                      controller: _locationController,
                      label: 'From',
                      hintText: 'Location',
                    ),
                    SizedBox(height: isTablet ? 18 : 8),
                    _buildTextField(
                      controller: _birthDateController,
                      label: 'Born on',
                      hintText: 'Birth date',
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: isTablet ? 18 : 8),
                    _buildTextField(
                      controller: _birthTimeController,
                      label: 'At',
                      hintText: 'Birth time',
                      onTap: () => _selectTime(context),
                    ),
                  ],
                 SizedBox(height: isTablet ? 18 : 8),

Padding(
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.03, 
    vertical: MediaQuery.of(context).size.height * 0.01
  ),
  child: SizedBox(
    height: MediaQuery.of(context).size.height * 0.1, // Adjusted height for the text field
    width: MediaQuery.of(context).size.width * 0.8,  // Adjusted width for the text field
    child: TextField(
      controller: _emailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFFF9933), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFFF9933), width: 1.0),
        ),
        hintText: 'Enter your email',
        hintStyle: TextStyle(
            color: Colors.white70,
            fontFamily: 'Inter',
            fontSize: MediaQuery.of(context).size.width * 0.03),
        suffixIcon: _isLoading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.arrow_forward, color: Color(0xFFFF9933)),
                onPressed: () => _isLoginMode
                    ? _loginUser(context, _isLoginMode)
                    : _signupAndNavigateToOTP(context, _isLoginMode),
              ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Inter',
          fontSize: MediaQuery.of(context).size.width * 0.03),
    ),
  ),
),

// // Adjust the gap between the email input and the next section
// SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 2% of screen height

GestureDetector(
  onTap: _toggleLoginMode,
  child: Text(
    _isLoginMode ? 'Switch to Sign Up' : 'I already have an account',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: const Color.fromARGB(255, 225, 176, 137),
      fontFamily: 'Inter',
      fontSize: MediaQuery.of(context).size.width * 0.03,
      fontWeight: FontWeight.w100,
    ),
  ),
),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required String hintText,
  GestureTapCallback? onTap,
}) {
  // Get screen width and height using MediaQuery
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  // Determine padding and font size based on screen size
  double horizontalPadding = screenWidth * 0.05; // 5% of screen width
  double verticalPadding = screenHeight * 0.015; // 1.5% of screen height
  double fontSize = screenWidth * 0.03; // 4% of screen width for font size

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label text widget
        Container(
          width: screenWidth * 0.15, // Adjust the width based on screen size (30% of screen width)
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Inter',
              fontSize: fontSize, // Adjust font size based on screen size
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.03), // Space between label and text field (3% of screen width)
        // Text field container
        Expanded(
          child: SizedBox(
            height: screenHeight * 0.05, // Adjust height based on screen height (5% of screen height)
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03, // Padding inside text field (3% of screen width)
                  vertical: screenHeight * 0.01, // Padding inside text field (1% of screen height)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFFF9933), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFFFF9933), width: 1.0),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.white70, fontFamily: 'Inter', fontSize: fontSize),
              ),
              keyboardType: onTap == null ? TextInputType.text : TextInputType.datetime,
              style: TextStyle(
                color: Colors.white70,
                fontFamily: 'Inter',
                fontSize: fontSize, // Consistent font size for input
              ),
              onTap: onTap,
            ),
          ),
        ),
      ],
    ),
  );
}


  // Method to toggle between signup and login modes
  void _toggleLoginMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _nameController.clear();
      _birthDateController.clear();
      _birthTimeController.clear();
      _locationController.clear();
      _emailController.clear();
    });
  }

  void _loginUser(BuildContext context, bool isLoginMode) async {
    if (_emailController.text.isNotEmpty) {
      String email = _emailController.text;

      setState(() {
        _isLoading = true;
      });

      try {
        bool isLoggedIn = await _signUpRepo.login(email);

        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OtpOverlay(email: email, isLoginMode: isLoginMode)),
          );
        } else {
          _showSnackBar(context, 'Email not registered. Please sign up.');
        }
      } catch (e) {
        print('Login error: $e');
        _showSnackBar(context, 'An error occurred during login.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showSnackBar(context, 'Please enter your email.');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _birthTimeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _signupAndNavigateToOTP(BuildContext context, bool isLoginMode) async {
    if (_validateInputs()) {
      UserModel user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        cityId: _locationController.text,
        dob: _birthDateController.text,
        tob: _birthTimeController.text,
      );

      setState(() {
        _isLoading = true;
      });

      try {
        bool isSignedUp = await _signUpRepo.signUp(user);
        if (isSignedUp) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OtpOverlay(email: user.email, isLoginMode: isLoginMode)),
          );
        } else {
          _showSnackBar(
              context, 'This email is already registered! Try logging in.');
        }
      } catch (e) {
        print('Signup error: $e');
        _showSnackBar(context, 'An error occurred during signup.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _birthDateController.text.isNotEmpty &&
        _birthTimeController.text.isNotEmpty;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
