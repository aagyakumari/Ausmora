// lib/models/payment_option_model.dart
import 'package:flutter/material.dart';

class PaymentOption {
  final String imagePath;
  final VoidCallback onTap;

  PaymentOption({required this.imagePath, required this.onTap});
}