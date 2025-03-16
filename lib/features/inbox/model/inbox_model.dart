// lib/models/message_model.dart
import 'package:flutter/material.dart';

class Message {
  final String title;
  final String content;
  final Color categoryColor;

  Message(this.title, this.content, this.categoryColor);
}