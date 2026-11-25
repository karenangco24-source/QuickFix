import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../models/user_role.dart';
import '../repositories/auth_repository.dart';

class SignUpValidators {
  const SignUpValidators._();

  static String? password(String? value) {
    if ((value ?? '').isEmpty) return 'Please enter a password.';
    if (value!.length < 6) return 'Use at least 6 characters.';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Please confirm your password.';
    if (value != original) return 'Passwords do not match.';
    return null;
  }

  static String? accessCode(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Please enter the staff access code.';
    }
    return null;
  }
}

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel(this._authRepository);

  final AuthRepository _authRepository;

  UserRole _role = UserRole.student;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _disposed = false;
  String? _errorMessage;

  UserRole get role => _role;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;
  bool get isStaff => _role == UserRole.staff;

  void setRole(UserRole role) {
    _role = role;
    _errorMessage = null;
    _safeNotify();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    _safeNotify();
  }

  /// Returns true when the account was created (the person is now signed in).
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    String studentId = '',
    String course = '',
    String employeeId = '',
    String department = '',
    String staffAccessCode = '',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      await _authRepository.signUp(
        profile: UserProfile(
          fullName: fullName.trim(),
          email: email.trim(),
          role: _role,
          studentId: isStaff ? '' : studentId.trim(),
          course: isStaff ? '' : course.trim(),
          employeeId: isStaff ? employeeId.trim() : '',
          department: isStaff ? department.trim() : '',
        ),
        password: password,
        staffAccessCode: isStaff ? staffAccessCode : null,
      );
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Could not create your account. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}