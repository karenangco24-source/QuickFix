import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/report_repository.dart';

class MyReportsViewModel extends ChangeNotifier {
  MyReportsViewModel(this._repository);

  final ReportRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Report> _reports = const [];
  StreamSubscription<List<Report>>? _subscription;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => !_isLoading && _errorMessage == null && _reports.isEmpty;

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

  void loadReports() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.watchMyReports().listen(
      (reports) {
        _reports = reports;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object _) {
        _isLoading = false;
        _errorMessage = 'Could not load your reports. Please try again.';
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}