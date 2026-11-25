import 'dart:async';

import '../models/user_profile.dart';
import 'auth_repository.dart';
import 'profile_repository.dart';

class InMemoryProfileRepository implements ProfileRepository {
  InMemoryProfileRepository(this._auth);

  final AuthRepository _auth;
  final Map<String, UserProfile> _profiles = {};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  UserProfile? _current() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _profiles.putIfAbsent(user.id, () => user.initialProfile);
  }

  @override
  Future<UserProfile> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final profile = _current();
    if (profile == null) throw StateError('No signed-in user.');
    return profile;
  }

  @override
  Stream<UserProfile?> watchProfile() async* {
    yield _current();
    await for (final _ in _changes.stream) {
      yield _current();
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No signed-in user.');
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _profiles[user.id] = profile;
    _changes.add(null);
  }
}