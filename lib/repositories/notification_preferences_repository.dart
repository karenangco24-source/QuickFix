import '../models/notification_type.dart';

abstract class NotificationPreferencesRepository {
  Future<Map<NotificationType, bool>> getPreferences();
  Future<void> setEnabled(NotificationType type, bool enabled);
}