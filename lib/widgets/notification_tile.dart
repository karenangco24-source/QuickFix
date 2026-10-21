import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../theme/app_theme.dart';
import 'notification_style.dart';
import 'status_chip.dart';

/// One tappable notification in the Notifications list.
/// All cards share the app's white/yellow look. Unread items are marked by a
/// pale yellow fill, a yellow outline, a "NEW" text badge, and a bold title,
/// so color is never the only signal.
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
    final isUnread = !notification.isRead;

    // Solid colors (not see-through), so the card never looks muddy.
    final unreadFill =
        Color.alphaBlend(AppTheme.primaryYellow.withAlpha(46), Colors.white);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: isUnread ? unreadFill : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isUnread
              ? AppTheme.primaryYellow
              : AppTheme.darkText.withAlpha(31),
          width: isUnread ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryYellow.withAlpha(64),
                child: Icon(notification.type.icon, color: AppTheme.darkText),
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
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.darkText,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}