import 'package:flutter_application_1/features/compatibility/model/compatibility_model.dart';
import 'package:flutter_application_1/features/compatibility/repo/compatibility_repo.dart';

class CompatibilityService {
  final CompatibilityRepository _repository;

  CompatibilityService(this._repository);

  Future<Compatibility> getCompatibility(String date) {
    return _repository.fetchCompatibilityData(date);
  }
}
