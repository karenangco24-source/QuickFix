import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();

  Stream<UserProfile?> watchProfile();

  Future<void> saveProfile(UserProfile profile);
}