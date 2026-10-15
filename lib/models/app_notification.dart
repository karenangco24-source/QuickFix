import 'notification_type.dart';
import 'report_status.dart';

/// Immutable notification model.
/// Named AppNotification to avoid clashing with Flutter's own Notification class.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.reportId,
    required this.createdAt,
    this.status,
    this.isRead = false,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String reportId;
  final DateTime createdAt;

  /// The report status this notification is about (shown as a status chip).
  final ReportStatus? status;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      reportId: reportId,
      createdAt: createdAt,
      status: status,
      isRead: isRead ?? this.isRead,
    );
  }
}
