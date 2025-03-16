class QuestionCategory {
  final String id;
  final String category;
  final int orderId;
  final int categoryTypeId;
  final bool active;
  final DateTime updatedDate;
  final String updatedBy;
  final DateTime createdDate;
  final String createdBy;

  QuestionCategory({
    required this.id,
    required this.category,
    required this.orderId,
    required this.categoryTypeId,
    required this.active,
    required this.updatedDate,
    required this.updatedBy,
    required this.createdDate,
    required this.createdBy,
  });

  factory QuestionCategory.fromJson(Map<String, dynamic> json) {
    return QuestionCategory(
      id: json['_id'],
      category: json['category'],
      orderId: json['order_id'],
      categoryTypeId: json['category_type_id'],
      active: json['active'],
      updatedDate: DateTime.parse(json['updated_date']),
      updatedBy: json['updated_by'],
      createdDate: DateTime.parse(json['created_date']),
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'order_id': orderId,
      'category_type_id': categoryTypeId,
      'active': active,
      'updated_date': updatedDate.toIso8601String(),
      'updated_by': updatedBy,
      'created_date': createdDate.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
