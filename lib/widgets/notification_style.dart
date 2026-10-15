import 'package:flutter/material.dart';

import '../models/notification_type.dart';

/// UI styling for each notification type, kept out of the model.
/// Every type has an icon and a text label, so color is never the only signal.
extension NotificationTypeStyle on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.reportReceived:
        return Icons.mark_email_read_outlined;
      case NotificationType.statusUpdate:
        return Icons.autorenew;
      case NotificationType.issueResolved:
        return Icons.check_circle_outline;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.reportReceived:
        return Colors.blue.shade800;
      case NotificationType.statusUpdate:
        return Colors.deepPurple.shade700;
      case NotificationType.issueResolved:
        return Colors.green.shade800;
    }
  }
}
