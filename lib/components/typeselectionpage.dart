import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:flutter_application_1/features/ask_a_question/repo/ask_a_question_repo.dart';

class TypeSelectionPage extends StatefulWidget {
  final int typeId;

  const TypeSelectionPage({super.key, required this.typeId});

  @override
  _TypeSelectionPageState createState() => _TypeSelectionPageState();
}

class _TypeSelectionPageState extends State<TypeSelectionPage> {
  final AskQuestionRepository _askQuestionRepository = AskQuestionRepository();
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestionsByTypeId(widget.typeId);
  }

  Future<void> _loadQuestionsByTypeId(int typeId) async {
    try {
      final questionModels =
          await _askQuestionRepository.fetchQuestionsByTypeId(typeId);
      setState(() {
        questions = questionModels;
      });
    } catch (e) {
      // Handle error
      print('Error loading questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Questions'),
        backgroundColor: const Color(0xFFFF9933),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Questions',
              style: TextStyle(
                color: const Color(0xFFFF9933),
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: questions.isNotEmpty
                  ? ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return ListTile(
                          title: Text(question.question),
                          trailing: Text(
                            '\$${question.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFFFF9933),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No questions available')),
            ),
          ],
        ),
      ),
    );
  }
}
