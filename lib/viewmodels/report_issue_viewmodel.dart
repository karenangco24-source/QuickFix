import 'package:flutter/foundation.dart';

import '../models/notification_type.dart';
import '../models/report.dart';
import '../repositories/notification_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/report_repository.dart';

class ReportIssueViewModel extends ChangeNotifier {
  ReportIssueViewModel({
    required ReportRepository reportRepository,
    required NotificationRepository notificationRepository,
    required ProfileRepository profileRepository,
  })  : _reportRepository = reportRepository,
        _notificationRepository = notificationRepository,
        _profileRepository = profileRepository;

  final ReportRepository _reportRepository;
  final NotificationRepository _notificationRepository;
  final ProfileRepository _profileRepository;

  static const List<String> issueTypes = [
    'Damaged pavement',
    'Broken equipment',
    'Electrical issue',
    'Plumbing issue',
    'Lighting issue',
    'Other',
  ];

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<Report?> submit({
    required String title,
    required String description,
    required String category,
    required String location,
    String? photoPath,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final profile = await _profileRepository.getProfile();
      final report = await _reportRepository.submitReport(
        reporterName: profile.fullName,
        title: title,
        description: description,
        category: category,
        location: location,
        photoPath: photoPath,
      );

      try {
        await _notificationRepository.addNotification(
          userId: report.reporterId,
          type: NotificationType.reportReceived,
          title: 'Report received',
          message:
              'We received your report "${report.title}". The campus team will review it soon.',
          reportId: report.id,
          status: report.status,
        );
      } catch (_) {}

      return report;
    } catch (_) {
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}