import 'report_status.dart';

class Report {
  const Report({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    required this.submittedAt,
    this.photoPath,
    this.statusNote,
    this.proofPhotoPath,
    this.updatedByName,
    this.updatedAt,
  });

  final String id;
  final String reporterId;
  final String reporterName;
  final String title;
  final String description;
  final String category;
  final String location;
  final ReportStatus status;
  final DateTime submittedAt;

  final String? photoPath;

  final String? statusNote;
  final String? proofPhotoPath;
  final String? updatedByName;
  final DateTime? updatedAt;

  Report copyWith({
    ReportStatus? status,
    String? statusNote,
    String? proofPhotoPath,
    String? updatedByName,
    DateTime? updatedAt,
  }) {
    return Report(
      id: id,
      reporterId: reporterId,
      reporterName: reporterName,
      title: title,
      description: description,
      category: category,
      location: location,
      status: status ?? this.status,
      submittedAt: submittedAt,
      photoPath: photoPath,
      statusNote: statusNote ?? this.statusNote,
      proofPhotoPath: proofPhotoPath ?? this.proofPhotoPath,
      updatedByName: updatedByName ?? this.updatedByName,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}