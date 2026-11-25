enum UserRole {
  student,
  staff;

  String get label => this == UserRole.student ? 'Student' : 'Staff';
}