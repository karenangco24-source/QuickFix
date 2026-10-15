import '../models/user_profile.dart';

/// Small, focused contract for profile data (Interface Segregation):
/// it knows nothing about help topics or notifications.
abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> saveProfile(UserProfile profile);
}
