class Horoscope {
  final int rashiId;
  final int rating;
  final String description;

  Horoscope({
    required this.rashiId,
    required this.rating,
    required this.description,
  });

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      rashiId: json['rashi_id'],
      rating: json['rating'],
      description: json['description'],
    );
  }
}

class Auspicious {
  final int rashiId;
  final int rating;
  final String description;

  Auspicious({
    required this.rashiId,
    required this.rating,
    required this.description,
  });

  factory Auspicious.fromJson(Map<String, dynamic> json) {
    return Auspicious(
      rashiId: json['rashi_id'],
      rating: json['rating'],
      description: json['description'],
    );
  }
}

class DashboardData {
  final Horoscope horoscope;
  final String compatibility;
  final Auspicious auspicious;

  DashboardData({
    required this.horoscope,
    required this.compatibility,
    required this.auspicious,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      horoscope: Horoscope.fromJson(json['data']['horoscope']),
      compatibility: json['data']['compatibility'],
      auspicious: Auspicious.fromJson(json['data']['auspicious']),
    );
  }
}
