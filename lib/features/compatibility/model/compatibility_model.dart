class Compatibility {
  final String compatibility;

  Compatibility({
    required this.compatibility,
  });

  factory Compatibility.fromJson(String jsonString) {
    return Compatibility(
      compatibility: jsonString,
    );
  }
}
