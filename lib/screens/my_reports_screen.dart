import 'package:flutter/material.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/mock_report_repository.dart';
import '../repositories/report_repository.dart';
import '../viewmodels/my_reports_viewmodel.dart';
import '../widgets/report_card.dart';
import '../widgets/status_style.dart';
import 'report_details_screen.dart';

/// View only: draws what the ViewModel exposes and forwards user actions.
class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key, this.repository});

  /// Optional so the data source can be injected (e.g. for tests).
  /// Falls back to the mock repository for the prototype.
  final ReportRepository? repository;

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  late final MyReportsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel =
        MyReportsViewModel(widget.repository ?? MockReportRepository());
    _viewModel.loadReports();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openDetails(Report report) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReportDetailsScreen(report: report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reports')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.errorMessage != null) {
            return _MessageView(
              message: _viewModel.errorMessage!,
              actionLabel: 'Try again',
              onAction: _viewModel.loadReports,
            );
          }
          if (_viewModel.isEmpty) {
            return const _MessageView(
              message: 'You have not submitted any reports yet.',
            );
          }

          final groups = _viewModel.groupedByStatus.entries.toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final entry in groups) ...[
                _StatusHeader(status: entry.key, count: entry.value.length),
                for (final report in entry.value)
                  ReportCard(
                    report: report,
                    onTap: () => _openDetails(report),
                  ),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.status, required this.count});

  final ReportStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(status.icon, color: status.color),
          const SizedBox(width: 8),
          Text(
            '${status.label} ($count)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: status.color,
                ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
