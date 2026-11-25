import '../models/report.dart';

abstract class ReportRepository {
  Stream<List<Report>> watchMyReports();

  Future<Report> submitReport({
    required String reporterName,
    required String title,
    required String description,
    required String category,
    required String location,
    String? photoPath,
  });
}