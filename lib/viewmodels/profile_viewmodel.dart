import 'package:flutter/foundation.dart';

import '../models/help_topic.dart';
import '../models/notification_type.dart';
import '../models/user_profile.dart';
import '../repositories/help_repository.dart';
import '../repositories/profile_repository.dart';

/// State and logic for the Profile and Edit Profile screens.
/// Depends only on the repository abstractions.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required ProfileRepository profileRepository,
    required HelpRepository helpRepository,
  })  : _profileRepository = profileRepository,
        _helpRepository = helpRepository;

  final ProfileRepository _profileRepository;
  final HelpRepository _helpRepository;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  UserProfile? _profile;
  List<HelpTopic> _helpTopics = const [];
  final Map<NotificationType, bool> _notificationSettings = {
    for (final type in NotificationType.values) type: true,
  };

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  UserProfile? get profile => _profile;
  List<HelpTopic> get helpTopics => _helpTopics;

  /// Initials for the avatar, e.g. "Juan Dela Cruz" -> "JC".
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
    } catch (_) {
      _errorMessage = 'Could not load your profile. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setNotificationEnabled(NotificationType type, bool enabled) {
    _notificationSettings[type] = enabled;
    notifyListeners();
  }

  /// Returns true when the profile was saved.
  Future<bool> saveProfile({
    required String fullName,
    required String studentId,
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
