import 'dart:async';

import '../models/app_notification.dart';
import '../models/auth_user.dart';
import '../models/notification_type.dart';
import '../models/report_status.dart';
import 'auth_repository.dart';
import 'notification_preferences_repository.dart';
import 'notification_repository.dart';

class InMemoryNotificationRepository
    implements NotificationRepository, NotificationPreferencesRepository {
  InMemoryNotificationRepository(this._auth);

  final AuthRepository _auth;
  final Map<String, List<AppNotification>> _byUser = {};
  final Map<String, Map<NotificationType, bool>> _prefsByUser = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  AuthUser _requireUser() {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No signed-in user.');
    return user;
  }

  List<AppNotification> _current() {
    final user = _auth.currentUser;
    if (user == null) return const [];
    return List<AppNotification>.unmodifiable(
      _byUser[user.id] ?? const <AppNotification>[],
    );
  }

  Map<NotificationType, bool> _prefsFor(String userId) {
    return _prefsByUser.putIfAbsent(
      userId,
      () => {for (final type in NotificationType.values) type: true},
    );
  }

  @override
  Stream<List<AppNotification>> watchNotifications() async* {
    yield _current();
    await for (final _ in _changes.stream) {
      yield _current();
    }
  }

  @override
  Future<void> addNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String message,
    required String reportId,
    ReportStatus? status,
  }) async {
    if (!(_prefsFor(userId)[type] ?? true)) return;

    final notification = AppNotification(
      id: 'N-${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      title: title,
      message: message,
      reportId: reportId,
      status: status,
      createdAt: DateTime.now(),
    );
    _byUser.putIfAbsent(userId, () => <AppNotification>[]).insert(
          0,
          notification,
        );
    _changes.add(null);
  }

  @override
  Future<void> markAsRead(String id) async {
    final user = _requireUser();
    final list = _byUser[user.id];
    if (list == null) return;
    final index = list.indexWhere((n) => n.id == id);
    if (index == -1 || list[index].isRead) return;
    list[index] = list[index].copyWith(isRead: true);
    _changes.add(null);
  }

  @override
  Future<void> markAllAsRead() async {
    final user = _requireUser();
    final list = _byUser[user.id];
    if (list == null || list.every((n) => n.isRead)) return;
    _byUser[user.id] = list.map((n) => n.copyWith(isRead: true)).toList();
    _changes.add(null);
  }

  @override
  Future<Map<NotificationType, bool>> getPreferences() async {
    final user = _requireUser();
    return Map<NotificationType, bool>.of(_prefsFor(user.id));
  }

  @override
  Future<void> setEnabled(NotificationType type, bool enabled) async {
    final user = _requireUser();
    _prefsFor(user.id)[type] = enabled;
  }
}