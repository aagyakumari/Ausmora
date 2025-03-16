import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChatBoxPage extends StatelessWidget {
  static const routeName = '/chat';
  final Map<String, dynamic>? inquiry;
  final String inquiryId;

  const ChatBoxPage({super.key, this.inquiry, required this.inquiryId});

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
        return 'Unknown Category';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRead = inquiry?['is_read'] ?? false;
    bool isReplied = inquiry?['is_replied'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chat', style: TextStyle(color: Colors.black)),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.report, color: Colors.black),
            onSelected: (value) {
              if (value == 1) {
                print('Report button pressed');
              } else if (value == 2) {
                Clipboard.setData(ClipboardData(text: inquiryId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inquiry ID copied')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Report'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.copy, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Copy Inquiry ID'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (inquiry != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildUserInquiry(context, inquiry!),
                ),
              const SizedBox(height: 20),
              if (isReplied)
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildMessageBubble(
                    context,
                    'Reply:',
                    inquiry?['final_reading'] ?? 'No reply available',
                    Colors.blue.shade200,
                    inquiry?['final_reading_on'] ?? 'Date not available',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInquiry(BuildContext context, Map<String, dynamic> inquiry) {
    int categoryTypeId = inquiry['category_type_id'] ?? 0;
    String categoryName = _getCategoryName(categoryTypeId);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 216, 192),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Question:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(inquiry['question'] ?? 'No question provided'),
          const SizedBox(height: 5),
          Text('Category: $categoryName'),
          Text('Price: \$${inquiry['price']}'),
          Text(
              'Purchased on: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(inquiry['purchased_on']))}'),
          if (inquiry['is_read'] ?? false)
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text('Seen',
                  style: TextStyle(
                      color: Colors.green, fontStyle: FontStyle.italic)),
            ),
          _buildProfiles(inquiry),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    String title,
    String message,
    Color color,
    String date,
  ) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        const int maxStars = 5; // Max stars for rating
        const Color starColor = Color.fromARGB(255, 9, 33, 69); // Star color

        int selectedStars = inquiry?['rating'] ?? 0;
        bool isSubmitting = false;

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              Text(message, style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 5),
              Text(date,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.6))),
              const SizedBox(height: 10),
              Row(
                children: List.generate(maxStars, (index) {
                  return GestureDetector(
                    onTap: isSubmitting
                        ? null
                        : () async {
                            int newRating = index + 1;
                            setState(() {
                              selectedStars = newRating;
                              isSubmitting = true;
                            });

                            bool success = await _rateInquiry(inquiryId, newRating);

                            setState(() {
                              isSubmitting = false;
                              if (success) {
                                inquiry?['rating'] = newRating;
                              } else {
                                selectedStars = inquiry?['rating'] ?? 0;
                              }
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Rated $newRating stars'
                                    : 'Failed to rate. Try again.'),
                              ),
                            );
                          },
                    child: Icon(
                      index < selectedStars ? Icons.star : Icons.star_border,
                      color: starColor,
                      size: 20,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfiles(dynamic inquiry) {
    if (inquiry['profile1'] != null && inquiry['profile2'] != null) {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildProfileCard(inquiry['profile1'])),
            const SizedBox(width: 10),
            Expanded(child: _buildProfileCard(inquiry['profile2'])),
          ],
        ),
      );
    } else if (inquiry['profile1'] != null) {
      return Center(child: _buildProfileCard(inquiry['profile1']));
    } else if (inquiry['profile2'] != null) {
      return Center(child: _buildProfileCard(inquiry['profile2']));
    } else {
      return const SizedBox();
    }
  }

  Widget _buildProfileCard(dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_circle,
                  color: Colors.orange.shade600, size: 24),
              const SizedBox(width: 5),
              const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          Divider(color: Colors.orange.shade300),
          Text('Name: ${profile['name']}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('City: ${profile['city_id']}'),
          Text('DOB: ${profile['dob']}'),
          Text('TOB: ${profile['tob']}'),
        ],
      ),
    );
  }

  Future<bool> _rateInquiry(String inquiryId, int rating) async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token');

      if (token == null) {
        throw Exception('Token is not available');
      }

      final url =
          'http://145.223.23.200:3004/frontend/GuestInquiry/RateInquiry?inquiry_id=$inquiryId&rating=$rating';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Inquiry rated successfully');
        return true;
      } else {
        print('Failed to rate inquiry. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error rating inquiry: $e');
      return false;
    }
  }
}
