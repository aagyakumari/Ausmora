import 'package:flutter_application_1/features/support/model/support_model.dart';

class SupportService {
  void submitFeedback(FeedbackModel feedback) {
    // Here you would implement the logic to submit the feedback
    // For example, send the feedback to a server or save it locally
    print('Feedback submitted: ${feedback.feedback}');
  }
}
