class Question {
  final String id;
  final String question;
  final double price;
  final String questionCategoryId; // Added field for category ID
  final bool active;
  final DateTime updatedDate;
  final String updatedBy;
  final DateTime createdDate;
  final String createdBy;

  Question({
    required this.id,
    required this.question,
    required this.price,
    required this.questionCategoryId,
    required this.active,
    required this.updatedDate,
    required this.updatedBy,
    required this.createdDate,
    required this.createdBy,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      question: json['question'],
      price: json['price'].toDouble(),
      questionCategoryId: json['question_category_id'],
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
      'question': question,
      'price': price,
      'question_category_id': questionCategoryId,
      'active': active,
      'updated_date': updatedDate.toIso8601String(),
      'updated_by': updatedBy,
      'created_date': createdDate.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
