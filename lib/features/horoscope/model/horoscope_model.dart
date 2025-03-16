class Horoscope {
  final int rashiId;
  final int rating;
  final String description;

  Horoscope({
    required this.rashiId,
    required this.rating,
    required this.description,
  });

  // Factory method to create a Horoscope instance from JSON
  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      rashiId: json['rashi_id'] as int,
      rating: json['rating'] as int,
      description: json['description'] as String,
    );
  }

  // Method to convert a Horoscope instance into a Map (for saving in Hive)
  Map<String, dynamic> toJson() {
    return {
      'rashi_id': rashiId,
      'rating': rating,
      'description': description,
    };
  }
}
