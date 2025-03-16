// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_application_1/features/inbox/ui/chat_box_page.dart';
// import 'package:flutter_application_1/main.dart';

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   // Background message handler
//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     print('Background Message Title: ${message.notification?.title}');
//     print('Background Message Body: ${message.notification?.body}');
//     print('Background Message Payload: ${message.data}');

//     // You can extract the inquiryId from the data payload here.
//     String inquiryId = message.data['inquiry_id'] ?? '';  // Extract inquiryId

//     // Once the inquiryId is retrieved, navigate to the chat page
//     // if (inquiryId.isNotEmpty) {
//       navigatorKey.currentState?.pushNamed(
//         ChatBoxPage.routeName,
//         arguments: {'inquiryId': inquiryId}, // Pass inquiryId as an argument
//       );
//   }

//   // Foreground message handler
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;

//     // Extract inquiryId from message data
//     String inquiryId = message.data['inquiry_id'] ?? '';  // Example extraction

//     // If inquiryId is present, navigate to the ChatBoxPage
//     if (inquiryId.isNotEmpty) {
//       navigatorKey.currentState?.pushNamed(
//         ChatBoxPage.routeName,
//         arguments: {'inquiryId': inquiryId},  // Pass inquiryId as an argument
//       );
//     }
//   }

//   // Initialize notifications and permissions
//   Future<void> initNotifications() async {
//     // Request permission
//     await _firebaseMessaging.requestPermission();

//     // Get FCM Token
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('FCM Token: $fCMToken');

//     // Set up the background message handler
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen(handleMessage);
//   }
  
// }