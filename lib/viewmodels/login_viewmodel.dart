import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';

class LoginValidators {
  const LoginValidators._();

  static String? email(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Please enter your email.';
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').isEmpty) return 'Please enter your password.';
    return null;
  }
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._authRepository);

  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _disposed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    _safeNotify();
  }

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      await _authRepository.signIn(email: email.trim(), password: password);
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Could not sign in. Please try again.';
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