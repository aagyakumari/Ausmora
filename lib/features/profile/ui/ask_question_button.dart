// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/features/ask_a_question/ui/ask_a_question_page.dart';

// class AskQuestionButton extends StatelessWidget {
//   final double screenWidth;
//   final double screenHeight;

//   AskQuestionButton({required this.screenWidth, required this.screenHeight});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AskQuestionPage()),
//           );
//         },
//         child: Text(
//           'Ask a Question',
//           style: TextStyle(
//             fontSize: screenWidth * 0.05,
//             fontFamily: 'Inter',
//             color: Colors.white,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white,
//           backgroundColor: Color(0xFFFF9933),
//           padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           fixedSize: Size(screenWidth * 0.8, screenHeight * 0.07),
//           shadowColor: Colors.black,
//           elevation: 10,
//         ),
//       ),
//     );
//   }
// }
