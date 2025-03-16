// lib/services/payment_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/payment/model/payment_model.dart';
import 'package:flutter_application_1/features/payment/repo/payment_repo.dart';

class PaymentService {
  final PaymentRepository _repository = PaymentRepository();

  List<PaymentOption> fetchPaymentOptions(VoidCallback showSuccessOverlay) {
    return _repository.getPaymentOptions(showSuccessOverlay);
  }
}