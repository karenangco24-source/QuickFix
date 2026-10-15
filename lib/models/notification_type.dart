/// The three kinds of notification the app shows.
/// No Flutter/UI imports here: icons and colors live in
/// widgets/notification_style.dart.
enum NotificationType {
  reportReceived,
  statusUpdate,
  issueResolved;

  String get label {
    switch (this) {
      case NotificationType.reportReceived:
        return 'Report Received';
      case NotificationType.statusUpdate:
        return 'Status Update';
      case NotificationType.issueResolved:
        return 'Issue Resolved';
    }
  }
}
