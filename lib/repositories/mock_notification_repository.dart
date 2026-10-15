import '../models/app_notification.dart';
import '../models/notification_type.dart';
import '../models/report_status.dart';
import 'notification_repository.dart';

/// Prototype data source. Swap for a real implementation later.
class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _notifications;
  }

  static final List<AppNotification> _notifications = [
    AppNotification(
      id: 'N-001',
      type: NotificationType.reportReceived,
      title: 'Report received',
      message: 'We received your report "Broken light in hallway". The campus team will review it soon.',
      reportId: 'R-1001',
      status: ReportStatus.submitted,
      createdAt: DateTime(2026, 10, 14, 9, 31),
    ),
    AppNotification(
      id: 'N-002',
      type: NotificationType.statusUpdate,
      title: 'Status updated',
      message: 'Your report "Leaking faucet" is now being reviewed.',
      reportId: 'R-1002',
      status: ReportStatus.inReview,
      createdAt: DateTime(2026, 10, 12, 15, 0),
    ),
    AppNotification(
      id: 'N-003',
      type: NotificationType.reportReceived,
      title: 'Report received',
      message: 'We received your report "Leaking faucet". The campus team will review it soon.',
      reportId: 'R-1002',
      status: ReportStatus.submitted,
      isRead: true,
      createdAt: DateTime(2026, 10, 12, 14, 6),
    ),
    AppNotification(
      id: 'N-004',
      type: NotificationType.statusUpdate,
      title: 'Status updated',
      message: 'A staff member is now working on your report "Weak Wi-Fi signal".',
      reportId: 'R-1003',
      status: ReportStatus.inProgress,
      isRead: true,
      createdAt: DateTime(2026, 10, 10, 14, 0),
    ),
    AppNotification(
      id: 'N-005',
      type: NotificationType.issueResolved,
      title: 'Issue resolved',
      message: 'Your report "Projector not working" has been fixed. Please tell us if the problem returns.',
      reportId: 'R-1005',
      status: ReportStatus.resolved,
      createdAt: DateTime(2026, 10, 6, 10, 0),
    ),
    AppNotification(
      id: 'N-006',
      type: NotificationType.issueResolved,
      title: 'Issue resolved',
      message: 'Your report "Clogged drain" has been fixed. Please tell us if the problem returns.',
      reportId: 'R-1006',
      status: ReportStatus.resolved,
      isRead: true,
      createdAt: DateTime(2026, 10, 3, 9, 0),
    ),
  ];
}
