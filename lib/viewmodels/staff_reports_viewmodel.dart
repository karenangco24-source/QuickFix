import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/staff_report_repository.dart';

class StaffReportsViewModel extends ChangeNotifier {
  StaffReportsViewModel(this._repository);

  final StaffReportRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Report> _reports = const [];
  ReportStatus? _filter; 
  StreamSubscription<List<Report>>? _subscription;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ReportStatus? get selectedFilter => _filter;
  bool get isEmpty => !_isLoading && _errorMessage == null && _reports.isEmpty;

  int countFor(ReportStatus? status) => status == null
      ? _reports.length
      : _reports.where((r) => r.status == status).length;

  List<Report> get visibleReports {
    final items = _filter == null
        ? _reports.toList()
        : _reports.where((r) => r.status == _filter).toList();
    items.sort((a, b) {
      final byStatus = a.status.index.compareTo(b.status.index);
      return byStatus != 0
          ? byStatus
          : b.submittedAt.compareTo(a.submittedAt);
    });
    return items;
  }

  void load() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.watchAllReports().listen(
      (reports) {
        _reports = reports;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object _) {
        _isLoading = false;
        _errorMessage = 'Could not load the reports. Please try again.';
        notifyListeners();
      },
    );
  }

  void selectFilter(ReportStatus? status) {
    _filter = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}