import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';
import '../models/notification_type.dart';
import '../repositories/notification_repository.dart';

/// State and logic for the Notifications screen.
/// Depends only on the NotificationRepository abstraction.
class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel(this._repository);

  final NotificationRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<AppNotification> _all = const [];
  NotificationType? _filter; // null means "All"

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  NotificationType? get selectedFilter => _filter;
  bool get isEmpty => !_isLoading && _errorMessage == null && _all.isEmpty;
  int get unreadCount => _all.where((n) => !n.isRead).length;

  /// Notifications for the selected filter, newest first.
  List<AppNotification> get visibleNotifications {
    final items = _filter == null
        ? _all.toList()
        : _all.where((n) => n.type == _filter).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _all = await _repository.getNotifications();
    } catch (_) {
      _errorMessage = 'Could not load your notifications. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectFilter(NotificationType? type) {
    _filter = type;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _all.indexWhere((n) => n.id == id);
    if (index == -1 || _all[index].isRead) return;
    final updated = List<AppNotification>.of(_all);
    updated[index] = updated[index].copyWith(isRead: true);
    _all = updated;
    notifyListeners();
  }

  void markAllAsRead() {
    if (unreadCount == 0) return;
    _all = _all.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  /// Display-ready timestamp, e.g. "Oct 14, 9:31 AM".
  String timeText(AppNotification notification) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = notification.createdAt;
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${months[d.month - 1]} ${d.day}, $hour12:$minute $period';
  }
}
