class Settings {
  final String theme;

  Settings({required this.theme});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
    };
  }
}
