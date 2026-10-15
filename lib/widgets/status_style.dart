import 'package:flutter/material.dart';

import '../models/report_status.dart';

/// UI styling for each status, kept out of the model.
/// Color is never the only signal: every status also has an icon and a label.
extension ReportStatusStyle on ReportStatus {
  IconData get icon {
    switch (this) {
      case ReportStatus.submitted:
        return Icons.inbox_outlined;
      case ReportStatus.inReview:
        return Icons.search;
      case ReportStatus.inProgress:
        return Icons.build_outlined;
      case ReportStatus.resolved:
        return Icons.check_circle_outline;
    }
  }

  Color get color {
    switch (this) {
      case ReportStatus.submitted:
        return Colors.blue.shade800;
      case ReportStatus.inReview:
        return Colors.indigo.shade700;
      case ReportStatus.inProgress:
        return Colors.orange.shade900;
      case ReportStatus.resolved:
        return Colors.green.shade800;
    }
  }
}
