import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:flutter_application_1/features/profile/model/profile_model.dart';

class CircleWithNameWidget extends StatelessWidget {
  final String assetPath;
  final String name;
  final double screenWidth;
  final VoidCallback onTap;
  final Color primaryColor;

  const CircleWithNameWidget({super.key, 
    required this.assetPath,
    required this.name,
    required this.screenWidth,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: screenWidth * 0.22,
            height: screenWidth * 0.22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          name,
          style: TextStyle(fontSize: screenWidth * 0.04, color: primaryColor),
        ),
      ],
    );
  }
}

// void _showQuestionDetails(BuildContext context, Question question) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(
//             'Press the submit button if you are sure about this question.'),
//         content: Text(question.question),
//         actions: [
//           TextButton(
//             child: Text('Close'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           // Add more actions if needed
//         ],
//       );
//     },
//   );
// }

// void _showProfileDialog(BuildContext context, ProfileModel profile) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('User Profile'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildTextRow('Name', profile.name),
//           _buildTextRow('Date of Birth', profile.dob),
//           _buildTextRow('Place of Birth', profile.cityId),
//           _buildTextRow('Time of Birth', profile.tob),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTextRow(String label, String value) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
//       ),
//       SizedBox(height: 5),
//       Text(value), // Display the profile information
//       SizedBox(height: 10),
//     ],
//   );
// }
