import '../models/user_profile.dart';
import 'profile_repository.dart';

/// Prototype data source that keeps the profile in memory.
/// Edits survive while the app is running, but not after a restart.
class MockProfileRepository implements ProfileRepository {
  UserProfile _profile = const UserProfile(
    fullName: 'Juan Dela Cruz',
    studentId: '2023-00123',
    email: 'juan.delacruz@school.edu',
    course: 'BS Computer Science',
  );

  @override
  Future<UserProfile> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _profile = profile;
  }
}
