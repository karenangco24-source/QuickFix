import 'package:flutter/foundation.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/report_repository.dart';

/// State and logic for the My Reports screen.
/// Depends only on the ReportRepository abstraction.
class MyReportsViewModel extends ChangeNotifier {
  MyReportsViewModel(this._repository);

  final ReportRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Report> _reports = const [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => !_isLoading && _errorMessage == null && _reports.isEmpty;

  /// Reports grouped by status, in the order of the ReportStatus enum.
  /// Newest reports come first inside each group. Empty groups are skipped.
  Map<ReportStatus, List<Report>> get groupedByStatus {
    final grouped = <ReportStatus, List<Report>>{};
    for (final status in ReportStatus.values) {
      final items = _reports.where((r) => r.status == status).toList()
        ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
      if (items.isNotEmpty) {
        grouped[status] = items;
      }
    }
    return grouped;
  }

  Future<void> loadReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reports = await _repository.getMyReports();
    } catch (_) {
      _errorMessage = 'Could not load your reports. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
