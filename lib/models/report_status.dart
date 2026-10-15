/// Domain-level status of a report.
/// No Flutter/UI imports here (Single Responsibility): colors and icons
/// live in widgets/status_style.dart.
enum ReportStatus {
  submitted,
  inReview,
  inProgress,
  resolved;

  String get label {
    switch (this) {
      case ReportStatus.submitted:
        return 'Submitted';
      case ReportStatus.inReview:
        return 'In Review';
      case ReportStatus.inProgress:
        return 'In Progress';
      case ReportStatus.resolved:
        return 'Resolved';
    }
  }

  /// Plain-language explanation shown on the Report Details screen.
  String get explanation {
    switch (this) {
      case ReportStatus.submitted:
        return 'Your report was received and is waiting to be reviewed by the campus team.';
      case ReportStatus.inReview:
        return 'The campus team is checking the details of your report and deciding who should handle it.';
      case ReportStatus.inProgress:
        return 'A staff member is currently working on fixing the issue.';
      case ReportStatus.resolved:
        return 'The issue has been fixed. If the problem comes back, you can submit a new report.';
    }
  }
}
