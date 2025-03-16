class PartnerDetailsModel {
  final String name;
  final String location;
  final String birthDate;
  final String birthTime;
  final String question;

  PartnerDetailsModel({
    required this.name,
    required this.location,
    required this.birthDate,
    required this.birthTime,
    required this.question,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'birthDate': birthDate,
      'birthTime': birthTime,
      'question': question,
    };
  }
}