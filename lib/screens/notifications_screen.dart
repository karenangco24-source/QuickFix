import 'package:flutter/material.dart';

import '../models/notification_type.dart';
import '../repositories/mock_notification_repository.dart';
import '../repositories/notification_repository.dart';
import '../viewmodels/notifications_viewmodel.dart';
import '../widgets/notification_tile.dart';

/// View only: draws what the ViewModel exposes and forwards user actions.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.repository});

  /// Optional so the data source can be injected (e.g. for tests).
  /// Falls back to the mock repository for the prototype.
  final NotificationRepository? repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationsViewModel(
      widget.repository ?? MockNotificationRepository(),
    );
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              TextButton(
                onPressed:
                    _viewModel.unreadCount == 0 ? null : _viewModel.markAllAsRead,
                child: const Text('Mark all read'),
              ),
            ],
          ),
          body: _buildBody(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_viewModel.errorMessage != null) {
      return _MessageView(
        message: _viewModel.errorMessage!,
        actionLabel: 'Try again',
        onAction: _viewModel.load,
      );
    }
    if (_viewModel.isEmpty) {
      return const _MessageView(message: 'You have no notifications yet.');
    }

    final items = _viewModel.visibleNotifications;
    final unread = _viewModel.unreadCount;

    return Column(
      children: [
        _FilterBar(
          selected: _viewModel.selectedFilter,
          onSelected: _viewModel.selectFilter,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              unread == 0 ? 'You are all caught up.' : '$unread unread',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const _MessageView(message: 'No notifications in this category.')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    for (final notification in items)
                      NotificationTile(
                        notification: notification,
                        timeText: _viewModel.timeText(notification),
                        onTap: () => _viewModel.markAsRead(notification.id),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final NotificationType? selected;
  final ValueChanged<NotificationType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final type in NotificationType.values) ...[
            const SizedBox(width: 8),
            FilterChip(
              label: Text(type.label),
              selected: selected == type,
              onSelected: (_) => onSelected(type),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
