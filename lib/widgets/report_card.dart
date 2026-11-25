import 'package:flutter/material.dart';

import '../models/report.dart';
import 'status_chip.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.onTap,
    this.showReporter = false,
  });

  final Report report;
  final VoidCallback onTap;
  final bool showReporter;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      report.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: report.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${report.category} • ${report.location}',
                style: textTheme.bodyMedium,
              ),
              if (showReporter) ...[
                const SizedBox(height: 4),
                Text(
                  'Reported by ${report.reporterName}',
                  style: textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}