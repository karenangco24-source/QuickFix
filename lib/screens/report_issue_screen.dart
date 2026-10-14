
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedIssueType;
  XFile? _selectedImage;

  bool _isSubmitting = false;

  final List<String> _issueTypes = [
    'Damaged pavement',
    'Broken equipment',
    'Electrical issue',
    'Plumbing issue',
    'Lighting issue',
    'Other',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (!mounted || image == null) return;

      setState(() {
        _selectedImage = image;
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

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Report Submitted!'),
        content: const Text(
          'Your report passed validation. '
          'Database submission and report tracking will be added later.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report an Issue',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'What needs fixing?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tell us about the problem so the right team can address it.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.mutedText,
                ),
              ),
              const SizedBox(height: 28),

              _buildLabel('Issue Type *'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedIssueType,
                isExpanded: true,
                decoration: _inputDecoration(
                  hint: 'Select the type of issue',
                  icon: Icons.category_outlined,
                ),
                items: _issueTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIssueType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an issue type.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),

              _buildLabel('Location *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hint: 'e.g. Library, 2nd floor, near Room 204',
                  icon: Icons.location_on_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the location.';
                  }
                  if (value.trim().length < 3) {
                    return 'Please provide a more specific location.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'Include the building, floor, room, or nearest landmark.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedText,
                ),
              ),
              const SizedBox(height: 22),

              _buildLabel('Description *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 6,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hint: 'Describe the problem and where it is happening...',
                  icon: Icons.description_outlined,
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe the issue.';
                  }
                  if (value.trim().length < 10) {
                    return 'Please provide at least 10 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('Photo (Optional)'),
              const SizedBox(height: 8),
              if (_selectedImage == null)
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('Attach a Photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.darkText,
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(
                      color: AppTheme.darkText.withValues(alpha: 0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.darkText.withValues(alpha: 0.15),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_selectedImage!.path),
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Photo attached',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove photo',
                        onPressed: _removeImage,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),

              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submitReport,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    _isSubmitting ? 'Submitting...' : 'Submit Report',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    foregroundColor: AppTheme.darkText,
                    disabledBackgroundColor:
                        AppTheme.primaryYellow.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '* Required fields',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppTheme.darkText,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppTheme.darkText.withValues(alpha: 0.15),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppTheme.darkText.withValues(alpha: 0.15),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.primaryYellow,
          width: 2,
        ),
      ),
    );
  }
}
