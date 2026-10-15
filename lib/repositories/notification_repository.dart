import '../models/app_notification.dart';

/// Abstraction the NotificationsViewModel depends on (Dependency Inversion).
/// A real backend or push service can replace the mock later without
/// changing the ViewModel or the screen (Open/Closed).
abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
}
