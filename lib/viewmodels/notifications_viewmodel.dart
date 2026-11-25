import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';
import '../models/notification_type.dart';
import '../repositories/notification_repository.dart';

class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel(this._repository);

  final NotificationRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<AppNotification> _all = const [];
  NotificationType? _filter; 
  StreamSubscription<List<AppNotification>>? _subscription;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  NotificationType? get selectedFilter => _filter;
  bool get isEmpty => !_isLoading && _errorMessage == null && _all.isEmpty;
  int get unreadCount => _all.where((n) => !n.isRead).length;

  List<AppNotification> get visibleNotifications {
    final items = _filter == null
        ? _all.toList()
        : _all.where((n) => n.type == _filter).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  void load() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.watchNotifications().listen(
      (items) {
        _all = items;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object _) {
        _isLoading = false;
        _errorMessage = 'Could not load your notifications. Please try again.';
        notifyListeners();
      },
    );
  }

  void selectFilter(NotificationType? type) {
    _filter = type;
    notifyListeners();
  }

  Future<void> markAsRead(String id) => _repository.markAsRead(id);

  Future<void> markAllAsRead() => _repository.markAllAsRead();

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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}