import 'package:flutter/foundation.dart';

import '../models/help_topic.dart';
import '../models/notification_type.dart';
import '../models/user_profile.dart';
import '../repositories/help_repository.dart';
import '../repositories/notification_preferences_repository.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required ProfileRepository profileRepository,
    required HelpRepository helpRepository,
    required NotificationPreferencesRepository notificationPreferences,
  })  : _profileRepository = profileRepository,
        _helpRepository = helpRepository,
        _notificationPreferences = notificationPreferences;

  final ProfileRepository _profileRepository;
  final HelpRepository _helpRepository;
  final NotificationPreferencesRepository _notificationPreferences;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  UserProfile? _profile;
  List<HelpTopic> _helpTopics = const [];
  Map<NotificationType, bool> _notificationSettings = const {};

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  UserProfile? get profile => _profile;
  List<HelpTopic> get helpTopics => _helpTopics;

  String get initials {
    final name = _profile?.fullName.trim() ?? '';
    final parts =
        name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  bool isNotificationEnabled(NotificationType type) =>
      _notificationSettings[type] ?? true;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.getProfile();
      _helpTopics = await _helpRepository.getHelpTopics();
      _notificationSettings = await _notificationPreferences.getPreferences();
    } catch (_) {
      _errorMessage = 'Could not load your profile. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setNotificationEnabled(
    NotificationType type,
    bool enabled,
  ) async {
    final previous = _notificationSettings;
    _notificationSettings = {...previous, type: enabled};
    notifyListeners();

    try {
      await _notificationPreferences.setEnabled(type, enabled);
    } catch (_) {
      _notificationSettings = previous;
      notifyListeners();
    }
  }

  Future<bool> saveProfile({
    required String fullName,
    required String studentId,
    required String course,
    required String employeeId,
    required String department,
    required String email,
    required String phone,
  }) async {
    final current = _profile;
    if (current == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final updated = current.copyWith(
        fullName: fullName,
        studentId: studentId,
        course: course,
        employeeId: employeeId,
        department: department,
        email: email,
        phone: phone,
      );
      await _profileRepository.saveProfile(updated);
      _profile = updated;
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}