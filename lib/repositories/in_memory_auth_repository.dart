import 'dart:async';

import '../models/auth_user.dart';
import '../models/user_profile.dart';
import '../models/user_role.dart';
import 'auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  static const String staffAccessCode = 'STAFF-2026';

  final Map<String, _Account> _accounts = {};
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();
  AuthUser? _user;

  @override
  AuthUser? get currentUser => _user;

  @override
  Stream<AuthUser?> authStateChanges() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final account = _accounts[_idFor(email)];
    if (account == null) {
      throw const AuthException(
        'No account found for this email. Please create one.',
      );
    }
    if (account.password != password) {
      throw const AuthException('Incorrect password.');
    }

    _user = account.user;
    _controller.add(_user);
  }

  @override
  Future<void> signUp({
    required UserProfile profile,
    required String password,
    String? staffAccessCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final id = _idFor(profile.email);
    if (_accounts.containsKey(id)) {
      throw const AuthException('An account with this email already exists.');
    }
    if (profile.role == UserRole.staff &&
        (staffAccessCode ?? '').trim() != InMemoryAuthRepository.staffAccessCode) {
      throw const AuthException('Invalid staff access code.');
    }

    final user = AuthUser(
      id: id,
      email: profile.email,
      initialProfile: profile,
    );
    _accounts[id] = _Account(password: password, user: user);
    _user = user;
    _controller.add(_user);
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  static String _idFor(String email) => email.trim().toLowerCase();
}

class _Account {
  const _Account({required this.password, required this.user});

  final String password;
  final AuthUser user;
}