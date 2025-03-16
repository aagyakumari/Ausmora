class SettingsRepository {
  // This class will handle fetching and storing user preferences
  // You can use SharedPreferences, a database, or other mechanisms

  Future<void> saveThemePreference(String theme) async {
    // Code to save theme preference
  }

  Future<String> getThemePreference() async {
    // Code to get theme preference
    return 'light'; // Default value
  }
}