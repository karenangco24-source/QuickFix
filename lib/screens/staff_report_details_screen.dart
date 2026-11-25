import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/notification_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/staff_report_repository.dart';
import '../theme/app_theme.dart';
import '../viewmodels/report_details_viewmodel.dart';
import '../viewmodels/status_update_viewmodel.dart';
import '../widgets/report_details_body.dart';

class StaffReportDetailsScreen extends StatefulWidget {
  const StaffReportDetailsScreen({
    super.key,
    required this.report,
    required this.reportRepository,
    required this.notificationRepository,
    required this.profileRepository,
  });

  final Report report;
  final StaffReportRepository reportRepository;
  final NotificationRepository notificationRepository;
  final ProfileRepository profileRepository;

  @override
  State<StaffReportDetailsScreen> createState() =>
      _StaffReportDetailsScreenState();
}

class _StaffReportDetailsScreenState extends State<StaffReportDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  late final StatusUpdateViewModel _viewModel;

  late Report _report;
  ReportStatus? _newStatus;
  XFile? _proof;
  bool _proofMissing = false;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
    _viewModel = StatusUpdateViewModel(
      reportRepository: widget.reportRepository,
      notificationRepository: widget.notificationRepository,
      profileRepository: widget.profileRepository,
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickProof() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (!mounted || image == null) return;
      setState(() {
        _proof = image;
        _proofMissing = false;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to select a photo. Please try again.'),
        ),
      );
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final formValid = _formKey.currentState!.validate();
    final status = _newStatus;
    final proofMissing =
        status != null && StatusUpdateViewModel.requiresProof(status) && _proof == null;
    setState(() => _proofMissing = proofMissing);
    if (!formValid || status == null || proofMissing) return;

    final updated = await _viewModel.submit(
      report: _report,
      newStatus: status,
      note: _noteController.text.trim(),
      proofPhotoPath: _proof?.path,
    );
    if (!mounted) return;

    if (updated == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update the report. Please try again.'),
        ),
      );
      return;
    }

    setState(() {
      _report = updated;
      _newStatus = null;
      _proof = null;
      _proofMissing = false;
      _noteController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Status updated. The student was notified.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ReportDetailsBody(
            viewModel: ReportDetailsViewModel(_report),
            forStaff: true,
          ),
          const SizedBox(height: 24),
          _buildUpdateSection(context),
        ],
      ),
    );
  }

  Widget _buildUpdateSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final options = StatusUpdateViewModel.nextStatuses(_report.status);

    if (options.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline),
              SizedBox(width: 12),
              Expanded(
                child: Text('This report is resolved. No further updates are needed.'),
              ),
            ],
          ),
        ),
      );
    }

    final selected = _newStatus;
    final needsNote =
        selected != null && StatusUpdateViewModel.requiresNote(selected);
    final needsProof =
        selected != null && StatusUpdateViewModel.requiresProof(selected);

    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Update status',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'In Progress needs a note. Resolved needs a note and a proof photo.',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ReportStatus>(
                key: ValueKey(_report.status),
                value: _newStatus,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'New status *',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: [
                  for (final status in options)
                    DropdownMenuItem(value: status, child: Text(status.label)),
                ],
                onChanged: (value) {
                  setState(() {
                    _newStatus = value;
                    if (value == null ||
                        !StatusUpdateViewModel.requiresProof(value)) {
                      _proof = null;
                      _proofMissing = false;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Please choose the new status.' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 5,
                maxLength: 300,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: needsNote ? 'Note *' : 'Note (optional)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'What was found or done?',
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    StatusUpdateViewModel.validateNote(_newStatus, value),
              ),
              if (needsProof) ...[
                const SizedBox(height: 12),
                Text(
                  'Proof photo *',
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                if (_proof == null)
                  OutlinedButton.icon(
                    onPressed: _pickProof,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Attach proof photo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.darkText,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  )
                else
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_proof!.path),
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Proof photo attached')),
                      IconButton(
                        tooltip: 'Remove photo',
                        onPressed: () => setState(() => _proof = null),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                if (_proofMissing) ...[
                  const SizedBox(height: 6),
                  Text(
                    'A proof photo is required to mark a report as resolved.',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ],
              ],
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  final isSaving = _viewModel.isSaving;
                  return SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: isSaving ? null : _save,
                      icon: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(isSaving ? 'Saving...' : 'Save update'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryYellow,
                        foregroundColor: AppTheme.darkText,
                        disabledBackgroundColor:
                            AppTheme.primaryYellow.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}