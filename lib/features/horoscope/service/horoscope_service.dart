import 'package:flutter_application_1/features/horoscope/model/horoscope_model.dart';
import 'package:flutter_application_1/features/horoscope/repo/horoscope_repo.dart';

class HoroscopeService {
  final HoroscopeRepository _repository;

  HoroscopeService(this._repository);

  Future<Horoscope> getHoroscope(String date) {
    return _repository.fetchHoroscopeData(date);
  }
}
