import 'package:flutter_application_1/features/auspicious_time/model/auspicious_time_model.dart';
import 'package:flutter_application_1/features/auspicious_time/repo/auspicious_time_repo.dart';

class AuspiciousService {
  final AuspiciousRepository _repository;

  AuspiciousService(this._repository);

  Future<Auspicious> getAuspicious(String date) {
    return _repository.fetchAuspiciousData(date);
  }
}
