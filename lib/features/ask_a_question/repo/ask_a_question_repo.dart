import 'dart:convert';
import 'package:flutter_application_1/features/ask_a_question/model/question_category_model.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart'; // Ensure Hive is set up for secure storage

class AskQuestionRepository {
  final String categoryUrl = "http://145.223.23.200:3004/frontend/GuestQuestion/GetQuestionCategory?type_id=0";
  final String questionUrl = "http://145.223.23.200:3004/frontend/GuestQuestion/GetQuestion?question_category_id=";
  final String bundleUrl = "http://145.223.23.200:3004/frontend/GuestQuestion/GetQuestion?is_bundle=true"; // Updated URL to reflect bundle data
  

  /// Fetch all categories with type_id=0
  Future<List<QuestionCategory>> fetchCategories() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      final response = await http.get(
        Uri.parse(categoryUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['question_category'] as List;
        return data.map((json) => QuestionCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Fetch categories filtered by `type_id`
  Future<List<QuestionCategory>> fetchCategoriesByTypeId(int typeId) async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      final String url = "http://145.223.23.200:3004/frontend/GuestQuestion/GetQuestionCategory?type_id=$typeId";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['question_category'] as List;
        return data.map((json) => QuestionCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories for type_id $typeId');
      }
    } catch (e) {
      throw Exception('Error fetching categories by type_id: $e');
    }
  }

  /// Fetch questions by `question_category_id`
 Future<List<Question>> fetchQuestions(String categoryId, {bool isBundle = false}) async {
  try {
    final box = Hive.box('settings');
    String? token = await box.get('token'); // Retrieve the token from Hive storage

    final String url = isBundle 
        ? bundleUrl // Use bundle URL if fetching bundle questions
        : "$questionUrl$categoryId"; // Otherwise, fetch questions normally

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Include the token in the request headers
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['questions'] as List;
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions for category_id $categoryId');
    }
  } catch (e) {
    throw Exception('Error fetching questions: $e');
  }
}


  /// Fetch questions filtered by `type_id`
  Future<List<Question>> fetchQuestionsByTypeId(int typeId) async {
    try {
      // Step 1: Fetch categories with the given type_id
      final List<QuestionCategory> categories = await fetchCategoriesByTypeId(typeId);

      if (categories.isEmpty) {
        return []; // No categories found for the given type_id
      }

      // Step 2: For each category, fetch its questions
      List<Question> allQuestions = [];

      for (var category in categories) {
        final questions = await fetchQuestions(category.id);
        allQuestions.addAll(questions);
      }

      return allQuestions;
    } catch (e) {
      throw Exception('Error fetching questions by type_id: $e');
    }
  }
}
