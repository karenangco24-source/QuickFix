import '../models/report.dart';
import '../models/report_status.dart';

class ReportDetailsViewModel {
  ReportDetailsViewModel(this.report);

  final Report report;

  String get title => report.title;
  String get description => report.description;
  String get category => report.category;
  String get location => report.location;
  String get reportId => report.id;
  String get reporterName => report.reporterName;
  String? get photoPath => report.photoPath;
  ReportStatus get status => report.status;
  String get statusLabel => report.status.label;
  String get statusExplanation => report.status.explanation;

  bool get hasStatusUpdate => report.updatedAt != null;
  String? get statusNote => report.statusNote;
  String? get proofPhotoPath => report.proofPhotoPath;
  String get updatedByName => report.updatedByName ?? 'Campus staff';

  String get submittedDateText => _format(report.submittedAt);

  String get updatedDateText {
    final updated = report.updatedAt;
    return updated == null ? '' : _format(updated);
  }

  String _format(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${months[d.month - 1]} ${d.day}, ${d.year} at $hour12:$minute $period';
  }
}