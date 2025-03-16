// lib/repository/astrologer_repository.dart

import 'package:flutter_application_1/features/astrologers/model/astrologer_model.dart';

class AstrologerRepository {
  Future<List<Astrologer>> fetchAstrologers() async {
    // Simulating network or local data fetching
    return [
      Astrologer(
        name: 'John Doe',
        specialization: 'Love & Relationships',
        imageUrl: 'assets/images/astrologer1.png',
      ),
      Astrologer(
        name: 'Jane Smith',
        specialization: 'Career Guidance',
        imageUrl: 'assets/images/astrologer2.png',
      ),
    ];
  }
}