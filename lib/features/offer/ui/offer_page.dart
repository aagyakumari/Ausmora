// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/components/typeselectionpage.dart';
// import 'package:flutter_application_1/features/offer/model/offer_model.dart';
// import 'package:flutter_application_1/features/offer/repo/offer_repo.dart';
// import 'package:flutter_application_1/features/offer/ui/offer_widget.dart';

// class OfferPage extends StatefulWidget {
//   final Offer offer;

//   const OfferPage({super.key, required this.offer});

//   @override
//   _OfferPageState createState() => _OfferPageState();
// }

// class _OfferPageState extends State<OfferPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   void _showQuestionsDialog(int typeId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TypeSelectionPage(typeId: typeId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Offer Details'),
//         backgroundColor: const Color(0xFFFF9933),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             OfferWidget(offer: widget.offer, tappable: false),
//             const SizedBox(height: 8),
//             Text(
//               'Details Table',
//               style: TextStyle(
//                 fontSize: screenWidth * 0.05,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               margin: const EdgeInsets.all(8.0),
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFFF9933).withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: DataTable(
//                 columnSpacing: screenWidth * 0.05,
//                 headingRowHeight: 48,
//                 dataRowHeight: 56,
//                 columns: [
//                   DataColumn(
//                     label: Expanded(
//                       child: Text(
//                         'Title',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: screenWidth * 0.04,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Expanded(
//                       child: Text(
//                         'Action',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: screenWidth * 0.04,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: [
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Horoscope',
//                         style: TextStyle(fontSize: screenWidth * 0.038),
//                       )),
//                       DataCell(
//                         GestureDetector(
//                           onTap: () => _showQuestionsDialog(1),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6.0, horizontal: 12.0),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFF9933),
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Text(
//                               'Choose',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: screenWidth * 0.035,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   DataRow(
//                     cells: [
//                       DataCell(Text(
//                         'Compatibility',
//                         style: TextStyle(fontSize: screenWidth * 0.038),
//                       )),
//                       DataCell(
//                         GestureDetector(
//                           onTap: () => _showQuestionsDialog(2),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6.0, horizontal: 12.0),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFF9933),
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Text(
//                               'Choose',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: screenWidth * 0.035,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
