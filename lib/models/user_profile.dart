/// Immutable data model for the signed-in student.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.studentId,
    required this.email,
    required this.course,
    this.phone = '',
  });

  final String fullName;
  final String studentId;
  final String email;
  final String course;
  final String phone;

  UserProfile copyWith({
    String? fullName,
    String? studentId,
    String? email,
    String? phone,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      course: course,
      phone: phone ?? this.phone,
    );
  }
}
