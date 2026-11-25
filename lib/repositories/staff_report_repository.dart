import '../models/report.dart';
import '../models/report_status.dart';

abstract class StaffReportRepository {
  Stream<List<Report>> watchAllReports();

  Future<Report> updateStatus({
    required String reportId,
    required ReportStatus status,
    required String note,
    required String updatedByName,
    String? proofPhotoPath,
  });
}