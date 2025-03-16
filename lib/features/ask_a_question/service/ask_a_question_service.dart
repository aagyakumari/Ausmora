import 'package:flutter_application_1/features/ask_a_question/model/question_category_model.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:flutter_application_1/features/ask_a_question/repo/ask_a_question_repo.dart';

class AskQuestionService {
  final AskQuestionRepository _repository = AskQuestionRepository();

  // Fetch categories from the repository
  Future<List<QuestionCategory>> getCategories() async {
    try {
      final categories = await _repository.fetchCategories();
      return categories;
    } catch (e) {
      // Handle or log the error if needed
      throw Exception('Error getting categories: $e');
    }
  }

  // Fetch categories filtered by type ID from the repository
  Future<List<QuestionCategory>> getCategoriesByTypeId(int typeId) async {
    try {
      final categories = await _repository.fetchCategoriesByTypeId(typeId);
      return categories;
    } catch (e) {
      // Handle or log the error if needed
      throw Exception('Error getting categories by type ID: $e');
    }
  }

  // Fetch questions based on category ID from the repository
  Future<List<Question>> getQuestions(String categoryId) async {
    try {
      final questions = await _repository.fetchQuestions(categoryId);
      return questions;
    } catch (e) {
      // Handle or log the error if needed
      throw Exception('Error getting questions: $e');
    }
  }

  // Fetch bundle questions
Future<List<Question>> getBundleQuestions(String categoryId) async {
  try {
    return await _repository.fetchQuestions(categoryId, isBundle: true);
  } catch (e) {
    throw Exception('Error getting bundle questions: $e');
  }
}


  // Fetch questions filtered by type ID from the repository
  Future<List<Question>> getQuestionsByTypeId(int typeId) async {
    try {
      final questions = await _repository.fetchQuestionsByTypeId(typeId);
      return questions;
    } catch (e) {
      // Handle or log the error if needed
      throw Exception('Error getting questions by type ID: $e');
    }
  }
}
