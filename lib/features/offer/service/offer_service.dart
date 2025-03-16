import 'package:flutter_application_1/features/offer/model/offer_model.dart';
import 'package:flutter_application_1/features/offer/repo/offer_repo.dart';

class OfferService {
  final OfferRepository _repository = OfferRepository();

  // Method to fetch and return top offers (top 5)
  Future<List<Offer>> getTopOffers() async {
    try {
      List<Offer> offers = await _repository.fetchOffers();
      return offers.take(5).toList(); // Return the top 5 offers
    } catch (e) {
      print('Error fetching top offers: $e');
      return []; // Return an empty list on error
    }
  }

  // Method to fetch and return all offers
  Future<List<Offer>> getAllOffers() async {
    try {
      List<Offer> offers = await _repository.fetchOffers();
      return offers; // Return all offers
    } catch (e) {
      print('Error fetching all offers: $e');
      return []; // Return an empty list on error
    }
  }
}
