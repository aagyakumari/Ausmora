// lib/services/astrologer_service.dart

import 'package:flutter_application_1/features/astrologers/model/astrologer_model.dart';
import 'package:flutter_application_1/features/astrologers/repo/astrologer_repo.dart';

class AstrologerService {
  final AstrologerRepository _repository;

  AstrologerService(this._repository);

  Future<List<Astrologer>> getAstrologers() async {
    // Fetch astrologers from the repository
    return await _repository.fetchAstrologers();
  }
}
