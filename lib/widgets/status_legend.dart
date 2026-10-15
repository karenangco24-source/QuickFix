import 'package:flutter/material.dart';

import '../models/report_status.dart';
import 'status_chip.dart';

/// Explains every report status using color + icon + text together,
/// so the meaning never depends on color alone.
class StatusLegend extends StatelessWidget {
  const StatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final status in ReportStatus.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusChip(status: status),
                const SizedBox(height: 6),
                Text(status.explanation, style: textTheme.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}
