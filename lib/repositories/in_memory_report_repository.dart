import 'dart:async';

import '../models/report.dart';
import '../models/report_status.dart';
import '../models/user_role.dart';
import 'auth_repository.dart';
import 'report_repository.dart';
import 'staff_report_repository.dart';

class InMemoryReportRepository
    implements ReportRepository, StaffReportRepository {
  InMemoryReportRepository(this._auth);

  final AuthRepository _auth;
  final List<Report> _reports = [];
  final StreamController<void> _changes = StreamController<void>.broadcast();

  List<Report> _mine() {
    final user = _auth.currentUser;
    if (user == null) return const [];
    return List<Report>.unmodifiable(
      _reports.where((r) => r.reporterId == user.id),
    );
  }

  List<Report> _all() {
    final user = _auth.currentUser;
    if (user == null || user.role != UserRole.staff) return const [];
    return List<Report>.unmodifiable(_reports);
  }

  @override
  Stream<List<Report>> watchMyReports() async* {
    yield _mine();
    await for (final _ in _changes.stream) {
      yield _mine();
    }
  }

  @override
  Stream<List<Report>> watchAllReports() async* {
    yield _all();
    await for (final _ in _changes.stream) {
      yield _all();
    }
  }

  @override
  Future<Report> submitReport({
    required String reporterName,
    required String title,
    required String description,
    required String category,
    required String location,
    String? photoPath,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.role != UserRole.student) {
      throw StateError('Only signed-in students can submit reports.');
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final stamp = DateTime.now().millisecondsSinceEpoch.toString();
    final report = Report(
      id: 'QF-${stamp.substring(stamp.length - 6)}',
      reporterId: user.id,
      reporterName: reporterName,
      title: title,
      description: description,
      category: category,
      location: location,
      status: ReportStatus.submitted,
      submittedAt: DateTime.now(),
      photoPath: photoPath,
    );

    _reports.insert(0, report);
    _changes.add(null);
    return report;
  }

  @override
  Future<Report> updateStatus({
    required String reportId,
    required ReportStatus status,
    required String note,
    required String updatedByName,
    String? proofPhotoPath,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.role != UserRole.staff) {
      throw StateError('Only staff can update a report status.');
    }

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index == -1) throw StateError('Report not found.');

    final updated = _reports[index].copyWith(
      status: status,
      statusNote: note,
      proofPhotoPath: proofPhotoPath,
      updatedByName: updatedByName,
      updatedAt: DateTime.now(),
    );
    _reports[index] = updated;
    _changes.add(null);
    return updated;
  }
}