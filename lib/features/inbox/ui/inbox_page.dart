import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topnavbar.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/inbox/ui/chat_box_page.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/support/ui/support_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  int? _selectedInquiryIndex; // To keep track of the selected inquiry
  final ScrollController _scrollController =
      ScrollController(); // ScrollController to manage scroll position
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  Future<List<dynamic>> _fetchInquiries() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');

      if (token == null) {
        throw Exception('Token is not available');
      }

      const url =
          'http://145.223.23.200:3004/frontend/GuestInquiry/MyInquiries';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['error_code'] == "0") {
          var inquiries = responseData['data']['inquiries'];
          if (inquiries is List) {
            return inquiries;
          } else {
            throw Exception(
                'Unexpected response format: inquiries is not a list');
          }
        } else {
          throw Exception('Error: ${responseData['message']}');
        }
      } else {
        throw Exception(
            'Failed to load inquiries: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching inquiries: $e');
      return [];
    }
  }

  Future<void> _markAsRead(String inquiryId) async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');

      if (token == null) {
        throw Exception('Token is not available');
      }

      final url =
          'http://145.223.23.200:3004/frontend/GuestInquiry/MarkAsRead?inquiry_id=$inquiryId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['error_code'] == "0") {
          print('Marked as read successfully');
        } else {
          throw Exception('Error: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to mark as read: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking inquiry as read: $e');
    }
  }

  // Function to map category_type_id to category names
  String _getCategoryName(int categoryTypeId) {
    switch (categoryTypeId) {
      case 1:
        return 'Horoscope';
      case 2:
        return 'Compatibility';
      case 3:
        return 'Auspicious Time';
      case 4:
        return 'Kundali';
      case 5:
        return 'Support';
      case 6:
        return 'Ask a Question';
      default:
        return 'Unknown Category'; // Handle any unknown categories
    }
  }

  // Function to build searchable inquiries list
  List<dynamic> _buildSearchableList(List<dynamic> inquiries) {
    return inquiries.where((inquiry) {
      String question = (inquiry['question'] ?? '').toLowerCase();
      String category =
          _getCategoryName(inquiry['category_type_id'] ?? 0).toLowerCase();
      String searchText = _searchText.toLowerCase();

      // Check if the search text is a substring of either the question or the category
      return question.contains(searchText) || category.contains(searchText);
    }).toList();
  }

  // Add a listener to update search text
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          final box = Hive.box('settings');
          final guestProfile = await box.get('guest_profile');

          if (guestProfile != null) {
            // Navigate to DashboardPage if guest_profile is not null
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          } else {
            // Navigate to MainLogoPage if guest_profile is null
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainLogoPage()),
            );
          }

          return false; // Prevent the default back button behavior
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Custom TopNavBar replacing the default AppBar
              TopNavBar(
                title: 'Inquiries',
                onLeftButtonPressed: () async {
                  final box = Hive.box('settings');
                  final guestProfile = await box.get('guest_profile');

                  if (guestProfile != null) {
                    // Navigate to DashboardPage if guest_profile is not null
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                    );
                  } else {
                    // Navigate to MainLogoPage if guest_profile is null
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainLogoPage()),
                    );
                  }
                },
                onRightButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportPage()),
                  );
                },
                leftIcon: Icons.arrow_back, // Icon for the left side
                rightIcon: Icons.help, // Icon for the right side
              ),

              // Search bar section with responsiveness
             Padding(
  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Smaller horizontal padding
  child: TextField(
    controller: _searchController,
    onChanged: (value) {
      setState(() {
        _searchText = value; // Update search text as user types
      });
    },
    decoration: InputDecoration(
      hintText: 'Search inquiries...',
      hintStyle: TextStyle(
        fontSize: screenWidth * 0.035, // Adjust the hint text size (smaller)
      ),
      prefixIcon: const Icon(Icons.search, color: Color(0xFFFF9933)),
      filled: true,
      fillColor: const Color.fromARGB(255, 212, 210, 210),
      border: InputBorder.none, // Remove border around TextField
    ),
  ),
),


              // FutureBuilder for inquiries
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchInquiries(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final inquiries = snapshot.data!;
                      final filteredInquiries = _buildSearchableList(inquiries);

                      if (filteredInquiries.isEmpty) {
                        return const Center(child: Text('No inquiries found.'));
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredInquiries.length,
                        itemBuilder: (context, index) {
                          final inquiry = filteredInquiries[index];
                          return _buildInquiryCard(
                              inquiry, index, screenHeight, screenWidth);
                        },
                      );
                    } else {
                      return const Center(child: Text('No data available.'));
                    }
                  },
                ),
              ),
            ],
          ),
          // Custom BottomNavBar added as bottom navigation
          bottomNavigationBar: BottomNavBar(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            currentPageIndex: 3, // Assuming index 1 represents Inbox
          ),
        ));
  }

 Widget _buildInquiryCard(
    dynamic inquiry, int index, double screenHeight, double screenWidth) {
  bool isRead = inquiry['is_read'] ?? false;
  bool isReplied = inquiry['is_replied'] ?? false;
  int categoryTypeId = inquiry['category_type_id'] ?? 0;
  String categoryName = _getCategoryName(categoryTypeId);

  // Map category_type_id to logo images
  String getLogo(int categoryTypeId) {
    switch (categoryTypeId) {
      case 1:
        return 'assets/images/horoscope2.png';
      case 2:
        return 'assets/images/compatibility2.png';
      case 3:
        return 'assets/images/auspicious2.png';
      case 4:
        return 'assets/images/kundali2.png';
      case 5:
        return 'assets/images/support2.png';
      case 6:
        return 'assets/images/aak.png';
      default:
        return 'assets/images/default.png'; // Fallback for unknown categories
    }
  }

  // Calculate responsive font sizes
  double titleFontSize = screenWidth * 0.025; // 2.5% of the screen width
  double subtitleFontSize = screenWidth * 0.02; // 2% of the screen width
  double logoSize = screenWidth * 0.08; // 8% of the screen width

  return Column(
    children: [
      InkWell(
        onTap: () async {
          await _markAsRead(inquiry['inquiry_id']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBoxPage(
                inquiry: inquiry,
                inquiryId: inquiry['inquiry_id'],
              ),
            ),
          );
          setState(() {
            _selectedInquiryIndex = index;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Ensures vertical alignment
            children: [
              // Placeholder for the unread dot (ensures alignment for read inquiries)
              Container(
                height: screenWidth * 0.02, // Small dot size
                width: screenWidth * 0.02,
                decoration: BoxDecoration(
                  color: !isRead ? Colors.orange : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: screenWidth * 0.03), // Space between dot and logo
              // Logo next to the dot
              Image.asset(
                getLogo(categoryTypeId),
                height: logoSize,
                width: logoSize,
              ),
              SizedBox(width: screenWidth * 0.03), // Space between logo and text
              // Inquiry details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$categoryName : ${inquiry['question']}',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), // Small spacing between title and subtitle
                    Text(
                      'Purchased on: ${inquiry['purchased_on']}',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Price: \$${inquiry['price']}',
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              // Status icon for "replied/pending"
              Container(
                height: screenWidth * 0.04, // Icon container size
                width: screenWidth * 0.04,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isReplied ? const Color(0xFFFF9933) : null,
                  shape: BoxShape.circle,
                ),
                child: isReplied
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: screenWidth * 0.03,
                      )
                    : Icon(
                        Icons.hourglass_empty,
                        color: Colors.orange,
                        size: screenWidth * 0.04,
                      ),
              ),
            ],
          ),
        ),
      ),
      // Divider to separate inquiries
      Divider(
        color: Colors.grey[300], // Subtle line color
        thickness: 1, // Line thickness
        indent: screenWidth * 0.05, // Start of the line
        endIndent: screenWidth * 0.05, // End of the line
      ),
    ],
  );
}
}