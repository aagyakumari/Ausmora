import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_application_1/features/auspicious_time/ui/auspicious_time_page.dart';
import 'package:flutter_application_1/features/compatibility/ui/compatibility_page.dart';
import 'package:flutter_application_1/features/horoscope/ui/horoscope_page.dart';
import 'package:flutter_application_1/features/inbox/ui/chat_box_page.dart';
import 'package:flutter_application_1/features/inbox/ui/inbox_page.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/dashboard/ui/dashboard_page.dart';
import 'package:flutter_application_1/features/sign_up/ui/w1_page.dart';
import 'package:hive/hive.dart';
import 'hive/hive_service.dart'; // Import your Hive service

final navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await createNotificationChannel(); // Create the notification channel
  // await initNotifications(); // Initialize notifications

  // Initialize Hive and run the app...
  HiveService hiveService = HiveService();
  try {
    await hiveService.initHive();

    // Check if the API URL already exists in Hive
    final existingToken = await hiveService.getToken();
    final existingApiUrl = await hiveService.getApiUrl();
    final existingOtpApiUrl = await hiveService.getOtpApiUrl();

    if (existingApiUrl == null) {
      await hiveService.saveApiData('http://145.223.23.200:3004/frontend/Guests/login', ''); // signup URL
    }

    if (existingOtpApiUrl == null) {
      await hiveService.saveOtpApiUrl('http://145.223.23.200:3004/frontend/Guests/ValidateOTP'); // OTP validation URL
    }

    runApp(MyApp(existingToken: existingToken));
  } catch (e) {
    print('Error initializing Hive: $e');
    runApp(ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  final String? existingToken;

  const MyApp({super.key, this.existingToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myFutureTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey, // Assign navigatorKey to the MaterialApp
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return ErrorApp();
          } else {
            return snapshot.data!;
          }
        },
      ),
      routes: {
        '/dashboard': (context) => DashboardPage(),
        '/horoscope': (context) => HoroscopePage(showBundleQuestions: false),
        '/compatibility': (context) => CompatibilityPage(),
        '/auspiciousTime': (context) => AuspiciousTimePage(showBundleQuestions: false),
        '/w1': (context) => W1Page(),
        '/mainlogo': (context) => MainLogoPage(),
        '/chat': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args != null) {
            return ChatBoxPage(
              inquiryId: args['inquiryId'] ?? '',
              inquiry: args['inquiry'],
            );
          } else {
            return Scaffold(
              body: Center(child: Text('No data provided for the chat')),
            );
          }
        },
        '/inbox': (context) => InboxPage(), // Add route for InboxPage
      },
    );
  }

  Future<Widget> _getInitialPage() async {
    final box = Hive.box('settings');
    final guestProfile = await box.get('guest_profile');
    final token = await box.get('token');

    if (token == null || token == "") {
      return W1Page();
    } else if (token != null && guestProfile == null) {
      return MainLogoPage();
    } else if (token != null && guestProfile != null) {
      return DashboardPage();
    } else {
      return W1Page();
    }
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      home: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Failed to initialize the app.')),
      ),
    );
  }
}

// Create a notification channel (for Android >= API 26)
Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your_channel_id', // ID
    'Your Channel Name', // Name
    description: 'This channel is used for important notifications.', // Description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Initialize Firebase Messaging and handle notifications
Future<void> initNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission
  await messaging.requestPermission();

  // Get FCM Token
  final fCMToken = await messaging.getToken();
  print('FCM Token: $fCMToken');

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen(handleForegroundMessage);

  // Handle when the app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleNotificationTap(message);
  });
}

// Foreground message handler
void handleForegroundMessage(RemoteMessage message) {
  if (message.notification != null) {
    final notification = message.notification!;
    final androidNotification = notification.android;

    if (androidNotification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id', // Unique channel ID
            'Your Channel Name', // Channel name
            channelDescription: 'Your channel description',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}

// Background message handler
// Background message handler (when the app is terminated or in the background)
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background Message Payload: ${message.data}');
  
  String inquiryId = message.data['inquiry_id'] ?? '';
  Map<String, dynamic>? inquiry;

  if (message.data['inquiry'] != null) {
    try {
      inquiry = jsonDecode(message.data['inquiry']); // Decode JSON string
    } catch (e) {
      print('Error decoding inquiry: $e');
    }
  }

  if (inquiryId.isNotEmpty) {
    navigatorKey.currentState?.pushNamed(
      '/chat',
      arguments: {'inquiryId': inquiryId, 'inquiry': inquiry},
    );
  }
}

// Handle notification tap
void handleNotificationTap(RemoteMessage message) {
  String inquiryId = message.data['inquiry_id'] ?? '';
  Map<String, dynamic>? inquiry;

  if (message.data['inquiry'] != null) {
    try {
      inquiry = jsonDecode(message.data['inquiry']); // Decode JSON string
    } catch (e) {
      print('Error decoding inquiry: $e');
    }
  }

  if (inquiryId.isNotEmpty) {
    navigatorKey.currentState?.pushNamed(
      '/chat',
      arguments: {'inquiryId': inquiryId, 'inquiry': inquiry},
    );
  }
}