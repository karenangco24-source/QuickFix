import 'report_status.dart';

/// Immutable data model for a submitted report.
class Report {
  const Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    required this.submittedAt,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final ReportStatus status;
  final DateTime submittedAt;
}
