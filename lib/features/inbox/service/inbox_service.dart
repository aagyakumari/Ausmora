// lib/services/message_service.dart
import 'package:flutter_application_1/features/inbox/model/inbox_model.dart';
import 'package:flutter_application_1/features/inbox/repo/inquiry_repo.dart';

class MessageService {
  final MessageRepository _repository = MessageRepository();

  List<Message> fetchMessages() {
    return _repository.getMessages();
  }
}