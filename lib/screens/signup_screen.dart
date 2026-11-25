import 'package:flutter/material.dart';

import '../models/user_role.dart';
import '../repositories/auth_repository.dart';
import '../theme/app_theme.dart';
import '../viewmodels/profile_validators.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../widgets/labeled_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _departmentController = TextEditingController();
  final _accessCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  late final SignUpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SignUpViewModel(widget.authRepository);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _courseController.dispose();
    _employeeIdController.dispose();
    _departmentController.dispose();
    _accessCodeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final created = await _viewModel.signUp(
      fullName: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      studentId: _studentIdController.text,
      course: _courseController.text,
      employeeId: _employeeIdController.text,
      department: _departmentController.text,
      staffAccessCode: _accessCodeController.text,
    );
    if (!mounted || !created) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create account',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                final isLoading = _viewModel.isLoading;
                final isStaff = _viewModel.isStaff;
                final error = _viewModel.errorMessage;

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Text(
                        'I am a...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<UserRole>(
                        segments: const [
                          ButtonSegment(
                            value: UserRole.student,
                            icon: Icon(Icons.school_outlined),
                            label: Text('Student'),
                          ),
                          ButtonSegment(
                            value: UserRole.staff,
                            icon: Icon(Icons.badge_outlined),
                            label: Text('Staff'),
                          ),
                        ],
                        selected: {_viewModel.role},
                        onSelectionChanged: isLoading
                            ? null
                            : (selection) =>
                                _viewModel.setRole(selection.first),
                      ),
                      const SizedBox(height: 24),
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
                        label: 'Email',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        hint: 'name@school.edu',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: ProfileValidators.email,
                      ),
                      const SizedBox(height: 24),
                      if (!isStaff) ...[
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
                          label: 'Course',
                          controller: _courseController,
                          icon: Icons.school_outlined,
                          hint: 'e.g. BS Computer Science',
                          textInputAction: TextInputAction.next,
                          isRequired: false,
                        ),
                      ] else ...[
                        LabeledTextField(
                          label: 'Employee ID',
                          controller: _employeeIdController,
                          icon: Icons.badge_outlined,
                          textInputAction: TextInputAction.next,
                          helper: 'Letters, numbers, or dashes.',
                          validator: ProfileValidators.employeeId,
                        ),
                        const SizedBox(height: 24),
                        LabeledTextField(
                          label: 'Department / office',
                          controller: _departmentController,
                          icon: Icons.apartment_outlined,
                          hint: 'e.g. Maintenance Office',
                          textInputAction: TextInputAction.next,
                          isRequired: false,
                        ),
                        const SizedBox(height: 24),
                        LabeledTextField(
                          label: 'Staff access code',
                          controller: _accessCodeController,
                          icon: Icons.key_outlined,
                          helper: 'Given to you by the school.',
                          textInputAction: TextInputAction.next,
                          validator: SignUpValidators.accessCode,
                        ),
                      ],
                      const SizedBox(height: 24),
                      LabeledTextField(
                        label: 'Password',
                        controller: _passwordController,
                        icon: Icons.lock_outline_rounded,
                        helper: 'At least 6 characters.',
                        obscureText: _viewModel.obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: SignUpValidators.password,
                        suffixIcon: IconButton(
                          tooltip: _viewModel.obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: _viewModel.togglePasswordVisibility,
                          icon: Icon(
                            _viewModel.obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      LabeledTextField(
                        label: 'Confirm password',
                        controller: _confirmController,
                        icon: Icons.lock_outline_rounded,
                        obscureText: _viewModel.obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) => SignUpValidators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),
                      if (error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade700),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: isLoading ? null : _submit,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.person_add_alt_1_rounded),
                          label: Text(
                            isLoading ? 'Creating account...' : 'Create account',
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
                      const SizedBox(height: 16),
                      Text(
                        '* Required fields',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}