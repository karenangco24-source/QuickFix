import '../models/report.dart';
import '../models/report_status.dart';

/// Presentation logic for the Report Details screen.
/// Turns a Report into display-ready text so the screen stays "dumb".
class ReportDetailsViewModel {
  ReportDetailsViewModel(this.report);

  final Report report;

  String get title => report.title;
  String get description => report.description;
  String get category => report.category;
  String get location => report.location;
  String get reportId => report.id;
  ReportStatus get status => report.status;
  String get statusLabel => report.status.label;
  String get statusExplanation => report.status.explanation;

  String get submittedDateText {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = report.submittedAt;
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${months[d.month - 1]} ${d.day}, ${d.year} at $hour12:$minute $period';
  }
}
