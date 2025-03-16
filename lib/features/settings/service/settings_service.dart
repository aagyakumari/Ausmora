import 'package:flutter_application_1/features/settings/repo/settings_repo.dart';

class SettingsService {
  final SettingsRepository _repository;

  SettingsService(this._repository);

  Future<void> updateThemePreference(String theme) async {
    await _repository.saveThemePreference(theme);
  }

  Future<String> fetchThemePreference() async {
    return await _repository.getThemePreference();
  }
}