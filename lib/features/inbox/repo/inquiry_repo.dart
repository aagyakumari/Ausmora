// lib/repositories/message_repository.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/inbox/model/inbox_model.dart';

class MessageRepository {
  List<Message> getMessages() {
    return [
      Message('Customer Support', 'We are here to help you!', Colors.blue),
      Message('Payment Details', 'Your payment was successful.', Colors.green),
      Message('From Astrologers', 'Your astrological reading is ready.', Colors.orange),
      Message('About Offers', 'Special discount just for you!', Colors.red),
      Message('Customer Support', 'How can we assist you?', Colors.blue),
      Message('Payment Details', 'Invoice for your last transaction.', Colors.green),
      Message('From Astrologers', 'New insights for you!', Colors.orange),
      Message('About Offers', 'Limited time offer!', Colors.red),
    ];
  }
}