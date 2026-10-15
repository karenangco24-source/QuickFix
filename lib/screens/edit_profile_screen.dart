import 'package:flutter/material.dart';

import '../viewmodels/profile_validators.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/labeled_text_field.dart';

/// View only: a form with visible labels. Validation rules live in
/// ProfileValidators, and saving is done by the ProfileViewModel.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _studentIdController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final profile = widget.viewModel.profile;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _studentIdController =
        TextEditingController(text: profile?.studentId ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final saved = await widget.viewModel.saveProfile(
      fullName: _nameController.text.trim(),
      studentId: _studentIdController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    if (!mounted) return;

    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your profile. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              LabeledTextField(
                label: 'Full name',
                controller: _nameController,
                icon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: ProfileValidators.fullName,
              ),
              const SizedBox(height: 24),
              LabeledTextField(
                label: 'Student ID',
                controller: _studentIdController,
                icon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                helper: 'Letters, numbers, or dashes.',
                validator: ProfileValidators.studentId,
              ),
              const SizedBox(height: 24),
              LabeledTextField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hint: 'name@school.edu',
                validator: ProfileValidators.email,
              ),
              const SizedBox(height: 24),
              LabeledTextField(
                label: 'Phone number',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                isRequired: false,
                validator: ProfileValidators.phone,
              ),
              const SizedBox(height: 32),
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  final isSaving = widget.viewModel.isSaving;
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: isSaving ? null : _save,
                          icon: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(isSaving ? 'Saving...' : 'Save changes'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: isSaving
                              ? null
                              : () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                '* Required fields',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
