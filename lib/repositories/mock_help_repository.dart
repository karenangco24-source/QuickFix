import '../models/help_topic.dart';
import 'help_repository.dart';

/// Prototype help content. Swap for a real source later.
class MockHelpRepository implements HelpRepository {
  @override
  Future<List<HelpTopic>> getHelpTopics() async {
    return _topics;
  }

  static const List<HelpTopic> _topics = [
    HelpTopic(
      question: 'How do I report an issue?',
      answer: 'Go to the Home tab and tap "Report an Issue". Choose the issue type, '
          'enter the location and a short description, then tap "Submit Report".',
    ),
    HelpTopic(
      question: 'Where can I see my reports?',
      answer: 'Open the My Reports tab. Your reports are grouped by status, and '
          'tapping a report shows its details and what its status means.',
    ),
    HelpTopic(
      question: 'Can I attach a photo?',
      answer: 'Yes. The photo is optional. Use "Attach a Photo" on the report form '
          'to pick one from your gallery.',
    ),
    HelpTopic(
      question: 'Who do I contact about an urgent problem?',
      answer: 'For anything dangerous, such as exposed wires or a flooded corridor, '
          'tell the nearest staff member or campus security right away, then submit a report.',
    ),
  ];
}
