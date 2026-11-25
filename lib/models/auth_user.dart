import 'user_profile.dart';
import 'user_role.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.initialProfile,
  });

  final String id;
  final String email;
  final UserProfile initialProfile;

  UserRole get role => initialProfile.role;
}