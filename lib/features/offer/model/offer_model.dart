import 'dart:convert';
import 'dart:typed_data';

class Offer {
  final String id;
  final String question;
  final String? imageBlob;
  final DateTime effectiveFrom;
  final DateTime effectiveTo;
  final bool active;
  final double price;
  final double priceBeforeDiscount;
  final double discountAmount;
  final bool isBundle;
  final String questionCategoryId;
  final int? categoryTypeId; // 🔹 Make nullable

  Offer({
    required this.id,
    required this.question,
    this.imageBlob,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.active,
    required this.price,
    required this.priceBeforeDiscount,
    required this.discountAmount,
    required this.isBundle,
    required this.questionCategoryId,
    this.categoryTypeId, // 🔹 Nullable to prevent crash
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'] ?? '', // Default empty string if null
      question: json['question'] ?? 'Unknown Question',
      imageBlob: json['image_blob'] ?? '',
      effectiveFrom: DateTime.tryParse(json['effective_from'] ?? '') ?? DateTime(2000, 1, 1), // Safe parsing
      effectiveTo: DateTime.tryParse(json['effective_to'] ?? '') ?? DateTime(2000, 1, 1),
      active: json['active'] ?? false,
      price: (json['price'] ?? 0).toDouble(), // Default 0 if null
      priceBeforeDiscount: (json['price_before_discount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      isBundle: json['is_bundle'] ?? false,
      questionCategoryId: json['question_category_id'] ?? '',
      categoryTypeId: json['category_type_id'] != null
          ? json['category_type_id'] as int
          : null, // 🔹 Handle null safely
    );
  }

  // Convert Base64 string to Uint8List for image display
  Uint8List? get imageData {
    if (imageBlob != null && imageBlob!.isNotEmpty) {
      return base64Decode(imageBlob!);
    }
    return null;
  }
}
