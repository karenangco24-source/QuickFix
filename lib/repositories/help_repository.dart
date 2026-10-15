import '../models/help_topic.dart';

/// Separate from ProfileRepository on purpose (Interface Segregation).
abstract class HelpRepository {
  Future<List<HelpTopic>> getHelpTopics();
}
