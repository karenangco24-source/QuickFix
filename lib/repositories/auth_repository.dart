import '../models/auth_user.dart';
import '../models/user_profile.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> authStateChanges();

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({
    required UserProfile profile,
    required String password,
    String? staffAccessCode,
  });

  Future<void> signOut();
}