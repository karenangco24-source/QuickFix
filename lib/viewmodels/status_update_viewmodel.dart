import 'package:flutter/foundation.dart';

import '../models/notification_type.dart';
import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/notification_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/staff_report_repository.dart';

class StatusUpdateViewModel extends ChangeNotifier {
  StatusUpdateViewModel({
    required StaffReportRepository reportRepository,
    required NotificationRepository notificationRepository,
    required ProfileRepository profileRepository,
  })  : _reportRepository = reportRepository,
        _notificationRepository = notificationRepository,
        _profileRepository = profileRepository;

  final StaffReportRepository _reportRepository;
  final NotificationRepository _notificationRepository;
  final ProfileRepository _profileRepository;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  static List<ReportStatus> nextStatuses(ReportStatus current) =>
      ReportStatus.values.where((s) => s.index > current.index).toList();

  static bool requiresNote(ReportStatus status) =>
      status == ReportStatus.inProgress || status == ReportStatus.resolved;

  static bool requiresProof(ReportStatus status) =>
      status == ReportStatus.resolved;

  static String? validateNote(ReportStatus? status, String? note) {
    final text = note?.trim() ?? '';
    if (status != null && requiresNote(status) && text.length < 5) {
      return 'Please write a short note (at least 5 characters) about what was done.';
    }
    return null;
  }

  Future<Report?> submit({
    required Report report,
    required ReportStatus newStatus,
    required String note,
    String? proofPhotoPath,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final staff = await _profileRepository.getProfile();
      final updated = await _reportRepository.updateStatus(
        reportId: report.id,
        status: newStatus,
        note: note,
        updatedByName: staff.fullName,
        proofPhotoPath: proofPhotoPath,
      );

      try {
        final isResolved = newStatus == ReportStatus.resolved;
        final message = switch (newStatus) {
          ReportStatus.inReview =>
            'Your report "${updated.title}" is now being reviewed.',
          ReportStatus.inProgress =>
            'A staff member is now working on your report "${updated.title}".',
          ReportStatus.resolved =>
            'Your report "${updated.title}" has been fixed. Please tell us if the problem returns.',
          ReportStatus.submitted =>
            'Your report "${updated.title}" was moved back to submitted.',
        };
        await _notificationRepository.addNotification(
          userId: updated.reporterId,
          type: isResolved
              ? NotificationType.issueResolved
              : NotificationType.statusUpdate,
          title: isResolved ? 'Issue resolved' : 'Status updated',
          message: message,
          reportId: updated.id,
          status: newStatus,
        );
      } catch (_) {}

      return updated;
    } catch (_) {
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}