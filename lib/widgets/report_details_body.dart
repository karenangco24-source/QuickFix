import 'dart:io';

import 'package:flutter/material.dart';

import '../viewmodels/report_details_viewmodel.dart';
import 'status_chip.dart';
import 'status_style.dart';

class ReportDetailsBody extends StatelessWidget {
  const ReportDetailsBody({
    super.key,
    required this.viewModel,
    this.forStaff = false,
  });

  final ReportDetailsViewModel viewModel;
  final bool forStaff;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = viewModel;
    final photoPath = vm.photoPath;
    final proofPath = vm.proofPhotoPath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                if (forStaff)
                  _InfoRow(label: 'Reported by', value: vm.reporterName),
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
        if (photoPath != null) ...[
          const SizedBox(height: 20),
          Text(
            'Photo',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _PhotoView(path: photoPath),
        ],
        if (vm.hasStatusUpdate) ...[
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest update',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By ${vm.updatedByName} • ${vm.updatedDateText}',
                    style: textTheme.bodySmall,
                  ),
                  if ((vm.statusNote ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(vm.statusNote!, style: textTheme.bodyMedium),
                  ],
                  if (proofPath != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Proof photo',
                      style: textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    _PhotoView(path: proofPath),
                  ],
                ],
              ),
            ),
          ),
        ],
        if (!forStaff) ...[
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
      ],
    );
  }
}

class _PhotoView extends StatelessWidget {
  const _PhotoView({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.file(
        File(path),
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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