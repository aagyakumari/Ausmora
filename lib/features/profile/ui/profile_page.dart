// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/features/profile/model/profile_model.dart';
// import 'package:flutter_application_1/features/profile/service/profile_services.dart';
// import 'package:flutter_application_1/features/profile/ui/ask_question_button.dart';
// import 'package:flutter_application_1/features/profile/ui/bottom_nav_bar.dart';
// import 'package:flutter_application_1/features/profile/ui/lucky_info_section.dart';
// import 'package:flutter_application_1/features/profile/ui/profile_details.dart';
// import 'package:flutter_application_1/features/profile/ui/profile_header.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController pobController = TextEditingController();
//   final TextEditingController tobController = TextEditingController();

//   File? _imageFile;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfile(); // Fetch profile data on initialization
//   }

//   Future<void> _fetchProfile() async {
//     // Fetch profile data
//     ProfileModel? profile = await ProfileServices.getProfile(); // Implement this method in ProfileServices
//     if (profile != null) {
//       setState(() {
//         // Update controllers with fetched data
//         nameController.text = profile.name;
//         dobController.text = profile.dob;
//         pobController.text = profile.city; // Assuming city corresponds to Place of Birth
//         tobController.text = profile.tob;
//         _imageFile = null; // Handle the image file if needed
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final imageFile = await ProfileServices.pickImage();
//     if (imageFile != null) {
//       setState(() {
//         _imageFile = imageFile;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ProfileHeader(screenWidth: screenWidth, screenHeight: screenHeight),
//               SizedBox(height: screenHeight * 0.05),
//               ProfileDetails(
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//                 nameController: nameController,
//                 dobController: dobController,
//                 pobController: pobController,
//                 tobController: tobController,
//                 imageFile: _imageFile,
//                 pickImage: _pickImage,
//               ),
//               SizedBox(height: screenHeight * 0.05),
//               LuckyInfoSection(screenWidth: screenWidth, screenHeight: screenHeight),
//               SizedBox(height: screenHeight * 0.05),
//               AskQuestionButton(screenWidth: screenWidth, screenHeight: screenHeight),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(screenWidth: screenWidth, screenHeight: screenHeight),
//     );
//   }
// }
