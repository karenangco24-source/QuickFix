import 'package:flutter/material.dart';

import '../models/report.dart';
import '../viewmodels/report_details_viewmodel.dart';
import '../widgets/status_chip.dart';
import '../widgets/status_style.dart';

/// View only: shows report information, its status, and what the status means.
class ReportDetailsScreen extends StatelessWidget {
  ReportDetailsScreen({super.key, required Report report})
      : _viewModel = ReportDetailsViewModel(report);

  final ReportDetailsViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = _viewModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            vm.title,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: StatusChip(status: vm.status),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(label: 'Report ID', value: vm.reportId),
                  _InfoRow(label: 'Category', value: vm.category),
                  _InfoRow(label: 'Location', value: vm.location),
                  _InfoRow(label: 'Submitted', value: vm.submittedDateText),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(vm.description, style: textTheme.bodyLarge),
          const SizedBox(height: 20),
          Card(
            color: vm.status.color.withAlpha(25),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(vm.status.icon, color: vm.status.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What "${vm.statusLabel}" means',
                          style: textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(vm.statusExplanation, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
