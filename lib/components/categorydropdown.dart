import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_category_model.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:flutter_application_1/features/ask_a_question/service/ask_a_question_service.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/payment/ui/payment_page.dart';
import 'package:flutter_application_1/hive/hive_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart'; // Import Hive package
import 'package:intl/intl.dart'; // Import intl package

class CategoryDropdown extends StatefulWidget {
  final int categoryTypeId;
  final Function(String, List<Question>) onQuestionsFetched;
  final Map<String, dynamic>? editedProfile;
  final Map<String, dynamic>? editedProfile2;

  final String inquiryType;
  final bool showBundleQuestions;

  const CategoryDropdown({
    // required this.onTap,
    required this.categoryTypeId,
    required this.onQuestionsFetched,
    this.editedProfile,
    this.editedProfile2,
    required this.inquiryType,
    this.showBundleQuestions = false,
    super.key,
  });

  @override
  CategoryDropdownState createState() => CategoryDropdownState();
}

class CategoryDropdownState extends State<CategoryDropdown> {
   // Initialize the ScrollController
  ScrollController _scrollController = ScrollController();
  final AskQuestionService _service = AskQuestionService();
  late Future<Map<int, List<QuestionCategory>>> _categoriesFuture;
  late Future<Map<String, List<Question>>> _questionsFuture;
  late Future<Map<String, dynamic>?> _profileFuture;
  String? selectedQuestionId;
  // Variables for storing the selected date
  String? auspicious_from_date;
  String? horoscope_from_date;
  bool _isAtBottom = false;

  Future<DateTime?> _selectDateWithMessage(
    BuildContext context, String selectedQuestion, double price) async {
  DateTime? selectedDate = DateTime.now(); // Set an initial date

  await showDialog(
    context: context,
    barrierDismissible: true, // Allow dismissing by tapping outside
    builder: (BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Subtle rounding
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Confirmation message at the top
              Padding(
                padding: EdgeInsets.only(bottom: screenWidth * 0.04), // Add bottom spacing
                child: Text(
                  'You want to choose "$selectedQuestion" for \$${price.toStringAsFixed(2)} from:',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // Responsive font size
                    fontWeight: FontWeight.w600,
                    color: Colors.orange, // Orange color
                  ),
                ),
              ),

              // Embedded Date Picker widget
              CalendarDatePicker(
                initialDate: selectedDate!,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                onDateChanged: (DateTime picked) {
                  selectedDate = picked; // Update the selected date
                },
              ),
              SizedBox(height: screenWidth * 0.04), // Add space before buttons

              // Cancel and Confirm buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      selectedDate =
                          null; // Explicitly set selectedDate to null on cancel
                      Navigator.pop(context,
                          null); // Return null to indicate no date was chosen
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 219, 35, 35), // Red color for Cancel
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                  ),

                  // Confirm Button
                  TextButton(
                    onPressed: () {
                      // Store the formatted date based on the page type
                      if (selectedDate != null) {
                        String formattedPicked =
                            DateFormat('yyyy-MM-dd').format(selectedDate!);

                        if (widget.inquiryType == 'auspicious_time') {
                          auspicious_from_date = formattedPicked;
                        } else if (widget.inquiryType == 'Horoscope') {
                          horoscope_from_date = formattedPicked;
                        }
                      }
                      Navigator.pop(context, selectedDate); // Return selected date
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.orange, // Orange color for Confirm
                        fontSize: screenWidth * 0.04, // Responsive font size
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

  return selectedDate; // Return the selected date (null if dialog is dismissed)
}

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
    if (widget.categoryTypeId != 6) {
      _questionsFuture = _fetchQuestionsForType(widget.categoryTypeId);
    }
    _profileFuture =
        _fetchProfileData(); // Initialize the future for profile data
        
       _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);   
  }

    void _scrollListener() {
    if (_scrollController.position.atEdge) {
      setState(() {
        _isAtBottom = _scrollController.position.pixels != 0;
      });
    }
  }

  Future<Map<int, List<QuestionCategory>>> _fetchCategories() async {
    try {
      final allCategories = await _service.getCategories();
      final categoriesByType = <int, List<QuestionCategory>>{};

      for (var category in allCategories) {
        if (category.categoryTypeId == widget.categoryTypeId) {
          if (categoriesByType[category.categoryTypeId] == null) {
            categoriesByType[category.categoryTypeId] = [];
          }
          categoriesByType[category.categoryTypeId]!.add(category);
        }
      }

      return categoriesByType;
    } catch (e) {
      print('Error fetching categories: $e');
      return {};
    }
  }

  Future<Map<String, List<Question>>> _fetchQuestions(String categoryId) async {
    try {
      final questions =
          await _service.getQuestionsByTypeId(widget.categoryTypeId);
      final questionsByCategoryId = <String, List<Question>>{};

      for (var question in questions) {
        if (questionsByCategoryId[question.questionCategoryId] == null) {
          questionsByCategoryId[question.questionCategoryId] = [];
        }
        questionsByCategoryId[question.questionCategoryId]!.add(question);
      }

      widget.onQuestionsFetched(
          categoryId, questionsByCategoryId[categoryId] ?? []);
      return questionsByCategoryId;
    } catch (e) {
      print('Error fetching questions: $e');
      return {};
    }
  }

  Future<Map<String, List<Question>>> _fetchQuestionsForType(int categoryTypeId) async {
  try {
    List<Question> questions;

    if (widget.showBundleQuestions) {
      questions = await _service.getBundleQuestions(categoryTypeId.toString());
    } else {
      questions = await _service.getQuestionsByTypeId(categoryTypeId);
    }

    final Map<String, List<Question>> questionsByCategoryId = {};

    for (var question in questions) {
      if (!questionsByCategoryId.containsKey(question.questionCategoryId)) {
        questionsByCategoryId[question.questionCategoryId] = [];
      }
      questionsByCategoryId[question.questionCategoryId]!.add(question);
    }

    return questionsByCategoryId;
  } catch (e) {
    print('Error fetching questions: $e');
    return {};
  }
}


  Future<Map<String, dynamic>?> _fetchProfileData() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');
      const url = 'http://145.223.23.200:3004/frontend/Guests/Get';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['error_code'] == "0") {
          return responseData['data']['item'];
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      return null;
    }
  }

  Future<void> handleTickIconTap() async {
    if (selectedQuestionId == null) {
      print('No question selected');
      return;
    }

    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');
      const url =
          'http://145.223.23.200:3004/frontend/GuestInquiry/StartInquiryProcess';
      final profile = widget.editedProfile ?? await _profileFuture;

      if (profile == null) {
        print('Profile data not available');
        return;
      }



// Build the initial body as a Map
      final body = {
        "inquiry_type": 0,
        "inquiry_regular": {
          "question_id": selectedQuestionId,
        },
        "profile1": {
          "name": profile['name'],
          "dob": profile['dob'],
          "city_id": profile['city_id'],
          "tob": profile['tob'],
        }
      };

      // If the inquiry is for compatibility, add profile2
      if (widget.inquiryType == 'compatibility' &&
          widget.editedProfile2 != null) {
        body['profile2'] = {
          "name": widget.editedProfile2!['name'],
          "dob": widget.editedProfile2!['dob'],
          "city_id": widget.editedProfile2!['city_id'],
          "tob": widget.editedProfile2!['tob'],
        };
      }

      // If the inquiry is for auspicious time, add the "auspicious_from_date" field
      if (widget.inquiryType == 'auspicious_time' &&
          auspicious_from_date != null) {
        body['auspicious_from_date'] = auspicious_from_date!;
      }

      // If the inquiry is for horoscope, add the "horoscope_from_date" field
      if (widget.inquiryType == 'Horoscope' && horoscope_from_date != null) {
        body['horoscope_from_date'] = horoscope_from_date!;
      }

      // Convert body to JSON string
      final bodyJson = jsonEncode(body);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyJson,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
      if (responseData['error_code'] == "0") {
        String inquiryNumber = responseData['data']['inquiry_number'];
        await HiveService().saveInquiryNumber(inquiryNumber);
        
        // Show success dialog
        _showResultDialog('Inquiry started successfully!', inquiryNumber);
      } else if (responseData['error_code'] == "1") {
        // Show error dialog for specific error message
        _showErrorDialog(responseData['message']);
      }
    } else {
      // Show error dialog for HTTP failure
      print('Failed to start inquiry: ${response.statusCode}');
      _showErrorDialog('Failed to start inquiry. Please try again later.');
    }
  } catch (e) {
    // Show error dialog for exceptions
    print('An error occurred: $e');
    _showErrorDialog('An error occurred. Please try again later.');
  }
}

 void _showResultDialog(String message, String? inquiryNumber) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Get screen size for responsive design
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      double iconSize = screenWidth * 0.1; // 10% of screen width for icon size
      double textSize = screenWidth * 0.05; // 5% of screen width for text size
      double inquiryTextSize = screenWidth * 0.04; // Slightly smaller for inquiry number

      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Small padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: iconSize), // Responsive icon size
            const SizedBox(height: 8), // Reduced spacing
            Text(
              'Success!',
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold), // Responsive text size
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 1, // Ensure the message is in a single line
              overflow: TextOverflow.ellipsis, // Handle overflow if text is too long
              style: TextStyle(fontSize: inquiryTextSize),
            ),
            if (inquiryNumber != null) ...[
              const SizedBox(height: 8),
              Text(
                'Inquiry Number: $inquiryNumber',
                style: TextStyle(
                  fontSize: inquiryTextSize,
                  overflow: TextOverflow.ellipsis, // Ensure it stays in a single line
                ),
                maxLines: 1, // Make sure inquiry number is also one line
              ),
            ],
          ],
        ),
       actions: [
  TextButton(
    onPressed: () async {
      final box = Hive.box('settings');
      final guestProfile = await box.get('guest_profile');

      Navigator.of(context).pop(); // Close the dialog

      if (guestProfile != null) {
        // Navigate to DashboardPage if guest_profile is not null
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false, // Remove all previous routes
        );
      } else {
        // Navigate to MainLogoPage if guest_profile is null
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainLogoPage()),
          (route) => false, // Remove all previous routes
        );
      }
    },
    child: Text(
      'OK',
      style: TextStyle(fontSize: textSize), // Responsive button text size
    ),
  ),
],

      );
    },
  );
}



void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 60), // Red exclamation
            const SizedBox(height: 16), // Spacing
            const Text(
              'Error',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Spacing
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
                (route) => false, // Remove all previous routes
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}




  // void _showQuestions(BuildContext context, String categoryId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return FutureBuilder<Map<String, List<Question>>>(
  //         future: _fetchQuestions(categoryId),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Center(child: CircularProgressIndicator());
  //           } else if (snapshot.hasError) {
  //             return AlertDialog(
  //               title: Text('Error'),
  //               content: Text('Error fetching questions: ${snapshot.error}'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             );
  //           } else if (!snapshot.hasData ||
  //               snapshot.data![categoryId] == null ||
  //               snapshot.data![categoryId]!.isEmpty) {
  //             return AlertDialog(
  //               title: Text('No questions available'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             );
  //           } else {
  //             final questions = snapshot.data![categoryId]!;
  //             return AlertDialog(
  //               title: Text('Select a Question'),
  //               content: SizedBox(
  //                 width: 400, // Fixed width
  //                 height: 500, // Fixed height
  //                 child: StatefulBuilder(
  //                   builder: (BuildContext context, StateSetter setState) {
  //                     return Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Expanded(
  //                           child: ListView(
  //                             shrinkWrap: true,
  //                             children: questions.map((question) {
  //                               final isSelected =
  //                                   selectedQuestionId == question.id;
  //                               return Card(
  //                                 elevation: 2,
  //                                 margin: EdgeInsets.symmetric(vertical: 4),
  //                                 shape: RoundedRectangleBorder(
  //                                   side: BorderSide(
  //                                       color: Color(0xFFFF9933), width: 1.0),
  //                                   borderRadius: BorderRadius.circular(4.0),
  //                                 ),
  //                                 color: isSelected
  //                                     ? Color(0xFFFF9933)
  //                                     : Colors.white,
  //                                 child: ListTile(
  //                                   contentPadding: EdgeInsets.all(8),
  //                                   title: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Expanded(
  //                                         child: Text(
  //                                           question.question,
  //                                           style: TextStyle(
  //                                             fontSize: 14, // Smaller font size
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       // Price display
  //                                       Column(
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.end,
  //                                         children: [
  //                                           Text(
  //                                             '\$${question.price.toStringAsFixed(2)}',
  //                                             style: TextStyle(
  //                                               fontSize:
  //                                                   14, // Smaller font size
  //                                               fontWeight: FontWeight.bold,
  //                                               color: isSelected
  //                                                   ? Colors.white
  //                                                   : Colors.green,
  //                                             ),
  //                                           ),
  //                                           if (isSelected)
  //                                             Icon(Icons.check_circle,
  //                                                 color: Colors.green,
  //                                                 size: 16),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   onTap: () {
  //                                     setState(() {
  //                                       selectedQuestionId = question.id;
  //                                     });
  //                                   },
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             TextButton(
  //                               onPressed: () {
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: Text('Cancel'),
  //                             ),
  //                             SizedBox(width: 8), // Space between buttons
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 if (selectedQuestionId != null) {
  //                                   // Get selected question
  //                                   final selectedQuestion =
  //                                       questions.firstWhere((question) =>
  //                                           question.id == selectedQuestionId);

  //                                   Navigator.of(context).pop();

  //                                   // Navigate to PaymentPage
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                       builder: (context) => PaymentPage(
  //                                         handleTickIconTap: handleTickIconTap,
  //                                         question: selectedQuestion.question,
  //                                         price: selectedQuestion.price,
  //                                         inquiryType: "Ask a Question",
  //                                       ),
  //                                     ),
  //                                   );
  //                                 } else {
  //                                   // Show a message if no question is selected
  //                                  ScaffoldMessenger.of(context).showSnackBar(
  //                                       SnackBar(
  //                                         content: Text(
  //                                           'Please select a question first.',
  //                                           style: TextStyle(color: Colors.white), // White text color
  //                                         ),
  //                                         backgroundColor: Colors.orange, // Orange background color
  //                                       ),
  //                                     );

  //                                 }
  //                               },
  //                               child: Text('OK'),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ),
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             );
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

//  void _showQuestionsDropdown(BuildContext context, String categoryId) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return FutureBuilder<Map<String, List<Question>>>(
//         future: _fetchQuestions(categoryId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching questions: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data![categoryId] == null || snapshot.data![categoryId]!.isEmpty) {
//             return Center(child: Text('No questions available.'));
//           } else {
//             final questions = snapshot.data![categoryId]!;
//             return ListView.builder(
//               itemCount: questions.length,
//               itemBuilder: (context, index) {
//                 final question = questions[index];
//                 return ListTile(
//                   title: Text(question.question),
//                   subtitle: Text('\$${question.price}'),
//                   onTap: ()async {
//                         selectedQuestionId = question.id;
//                         // String inquiryType;
                    
//                     // Directly navigate to the PaymentPage with the selected question
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PaymentPage(
//                           handleTickIconTap: handleTickIconTap,
//                           question: question.question,
//                           price: question.price,
//                           inquiryType: 'ask_a_question',
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       );
//     },
//   );
// }


@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  if (widget.categoryTypeId == 6) {
    return FutureBuilder<Map<int, List<QuestionCategory>>>(  // FutureBuilder to fetch categories
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching categories: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data![widget.categoryTypeId] == null || snapshot.data![widget.categoryTypeId]!.isEmpty) {
          return const Center(child: Text('No categories available.'));
        } else {
          final categories = snapshot.data![widget.categoryTypeId]!;
          return SingleChildScrollView(
            child: Column(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical padding between categories
                  child: Column(
                    children: [
                      // Category Title with consistent padding
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Horizontal padding
                        child: ExpansionTile(
                          title: Text(
                            category.category,
                            style: TextStyle(fontSize: screenWidth * 0.03), // Adjust font size
                          ),
                          trailing: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          children: [
                            // Fetch questions for the specific category directly
                            FutureBuilder<Map<String, List<Question>>>(  // Fetch questions based on category
                              future: _fetchQuestions(category.id.toString()),
                              builder: (context, questionSnapshot) {
                                if (questionSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (questionSnapshot.hasError) {
                                  return Center(child: Text('Error fetching questions: ${questionSnapshot.error}'));
                                } else if (!questionSnapshot.hasData || questionSnapshot.data![category.id.toString()] == null || questionSnapshot.data![category.id.toString()]!.isEmpty) {
                                  return const Center(child: Text('No questions available.'));
                                } else {
                                  final questions = questionSnapshot.data![category.id.toString()]!;
                                  return Column(
                                    children: [
                                      // Divider separating questions with consistent spacing
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Padding for divider
                                        child: Divider(color: Colors.grey.shade300, thickness: 1.0),
                                      ),
                                      ...questions.map((question) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0), // Vertical padding between questions
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 0.5),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.02, // Horizontal padding for question text
                                              ),
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      question.question,
                                                      style: TextStyle(fontSize: screenWidth * 0.03), // Adjust font size
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${question.price}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth * 0.03,
                                                      fontWeight: FontWeight.w400,
                                                      color: const Color(0xFFFF9933),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                selectedQuestionId = question.id;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PaymentPage(
                                                      handleTickIconTap: handleTickIconTap,
                                                      question: question.question,
                                                      price: question.price,
                                                      inquiryType: 'ask_a_question',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // Divider separating categories with consistent spacing
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Padding for divider
                        child: Divider(color: Colors.grey.shade300, thickness: 1.0),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }



  // Handle other cases here (if categoryTypeId is not 6)
else {
      return Center(
  child: FutureBuilder<Map<String, List<Question>>>(
    future: _questionsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text(
          'Error fetching questions: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text(
          'No questions available.',
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        );
      } else {
        final questions = snapshot.data!.values.expand((list) => list).toList();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.5, // Adjust this as needed
            ),
            child: Scrollbar( // Adds a scrollbar for better UX
              thumbVisibility: false,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 0.5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              question.question,
                              style: TextStyle(fontSize: screenWidth * 0.03),
                            ),
                          ),
                          Text(
                            '\$${question.price}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFFF9933),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        selectedQuestionId = question.id;
                        String inquiryType;

                        if (widget.categoryTypeId == 1) {
                          inquiryType = 'Horoscope';
                          final selectedDate = await _selectDateWithMessage(
                            context,
                            question.question,
                            question.price,
                          );
                          if (selectedDate != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  handleTickIconTap: handleTickIconTap,
                                  question: question.question,
                                  price: question.price,
                                  inquiryType: inquiryType,
                                ),
                              ),
                            );
                          }
                        } else if (widget.categoryTypeId == 2 &&
                            widget.editedProfile2 != null) {
                          inquiryType = 'Compatibility';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                handleTickIconTap: handleTickIconTap,
                                question: question.question,
                                price: question.price,
                                inquiryType: inquiryType,
                              ),
                            ),
                          );
                        } else if (widget.categoryTypeId == 2 &&
                            widget.editedProfile2 == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill in Person 2 details to proceed.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        } else if (widget.categoryTypeId == 3) {
                          inquiryType = 'Auspicious Time';
                          final selectedDate = await _selectDateWithMessage(
                            context,
                            question.question,
                            question.price,
                          );
                          if (selectedDate != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  handleTickIconTap: handleTickIconTap,
                                  question: question.question,
                                  price: question.price,
                                  inquiryType: inquiryType,
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    },
  ),
);

    }
  }
}