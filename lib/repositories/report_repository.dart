import '../models/report.dart';

/// Abstraction the ViewModels depend on (Dependency Inversion).
/// A real backend or database can replace the mock later without
/// changing any ViewModel or screen (Open/Closed).
abstract class ReportRepository {
  Future<List<Report>> getMyReports();
  Future<Report?> getReportById(String id);
}
