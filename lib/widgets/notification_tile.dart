import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import 'notification_style.dart';
import 'status_chip.dart';

/// One tappable notification in the Notifications list.
/// Unread items show a "NEW" text badge and bold title, not just a color.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.timeText,
    required this.onTap,
  });

  final AppNotification notification;
  final String timeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final type = notification.type;
    final isUnread = !notification.isRead;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: isUnread ? type.color.withAlpha(18) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: type.color.withAlpha(30),
                child: Icon(type.icon, color: type.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight:
                                  isUnread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isUnread) const _NewBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notification.message, style: textTheme.bodyMedium),
                    if (notification.status != null) ...[
                      const SizedBox(height: 8),
                      StatusChip(status: notification.status!),
                    ],
                    const SizedBox(height: 8),
                    Text(timeText, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'NEW',
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
