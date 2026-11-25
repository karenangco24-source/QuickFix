import 'package:flutter/material.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/notification_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/staff_report_repository.dart';
import '../viewmodels/staff_reports_viewmodel.dart';
import '../widgets/report_card.dart';
import 'staff_report_details_screen.dart';

class StaffReportsScreen extends StatefulWidget {
  const StaffReportsScreen({
    super.key,
    required this.reportRepository,
    required this.notificationRepository,
    required this.profileRepository,
  });

  final StaffReportRepository reportRepository;
  final NotificationRepository notificationRepository;
  final ProfileRepository profileRepository;

  @override
  State<StaffReportsScreen> createState() => _StaffReportsScreenState();
}

class _StaffReportsScreenState extends State<StaffReportsScreen> {
  late final StaffReportsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StaffReportsViewModel(widget.reportRepository);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openDetails(Report report) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StaffReportDetailsScreen(
          report: report,
          reportRepository: widget.reportRepository,
          notificationRepository: widget.notificationRepository,
          profileRepository: widget.profileRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
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
              onAction: _viewModel.load,
            );
          }
          if (_viewModel.isEmpty) {
            return const _MessageView(
              message: 'No reports have been submitted yet.',
            );
          }

          final items = _viewModel.visibleReports;
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    FilterChip(
                      label: Text('All (${_viewModel.countFor(null)})'),
                      selected: _viewModel.selectedFilter == null,
                      onSelected: (_) => _viewModel.selectFilter(null),
                    ),
                    for (final status in ReportStatus.values) ...[
                      const SizedBox(width: 8),
                      FilterChip(
                        label: Text(
                          '${status.label} (${_viewModel.countFor(status)})',
                        ),
                        selected: _viewModel.selectedFilter == status,
                        onSelected: (_) => _viewModel.selectFilter(status),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const _MessageView(
                        message: 'No reports with this status.',
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        children: [
                          for (final report in items)
                            ReportCard(
                              report: report,
                              showReporter: true,
                              onTap: () => _openDetails(report),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
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