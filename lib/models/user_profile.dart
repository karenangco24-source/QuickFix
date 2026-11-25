import 'user_role.dart';

class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    this.role = UserRole.student,
    this.studentId = '',
    this.course = '',
    this.employeeId = '',
    this.department = '',
    this.phone = '',
  });

  final String fullName;
  final String email;
  final UserRole role;
  final String studentId; 
  final String course;
  final String employeeId; 
  final String department; 
  final String phone;

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? studentId,
    String? course,
    String? employeeId,
    String? department,
    String? phone,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role,
      studentId: studentId ?? this.studentId,
      course: course ?? this.course,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      phone: phone ?? this.phone,
    );
  }
}