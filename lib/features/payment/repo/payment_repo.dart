// lib/repositories/payment_repository.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/payment/model/payment_model.dart';

class PaymentRepository {
  List<PaymentOption> getPaymentOptions(VoidCallback showSuccessOverlay) {
    return [
      PaymentOption(
        imagePath: 'assets/images/googlepay.png',
        onTap: showSuccessOverlay,
      ),
      PaymentOption(
        imagePath: 'assets/images/applepay.png',
        onTap: showSuccessOverlay,
      ),
      PaymentOption(
        imagePath: 'assets/images/paypal.png',
        onTap: showSuccessOverlay,
      ),
    ];
  }
}