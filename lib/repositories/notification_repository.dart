import '../models/app_notification.dart';
import '../models/notification_type.dart';
import '../models/report_status.dart';

abstract class NotificationRepository {
  Stream<List<AppNotification>> watchNotifications();

  Future<void> addNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    required String reportId,
    ReportStatus? status,
  });

  Future<void> markAsRead(String id);

  Future<void> markAllAsRead();
}