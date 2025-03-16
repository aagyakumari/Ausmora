import 'package:flutter_application_1/features/dashboard/repo/dashboard_repo.dart';
import 'package:flutter_application_1/features/dashboard/model/dashboard_model.dart';

class DashboardService {
  final DashboardRepository _repository = DashboardRepository();

  Future<List<String>> getOfferImages() {
    return _repository.fetchOfferImages();
  }

  Future<DashboardData> getDashboardData(String date) {
    return _repository.fetchDashboardData(date);
  }
}
