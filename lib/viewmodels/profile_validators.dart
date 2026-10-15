/// Form validation rules for the Edit Profile screen.
/// Kept out of the screen so the View stays free of business rules.
class ProfileValidators {
  const ProfileValidators._();

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your full name.';
    if (text.length < 3) return 'Please enter at least 3 characters.';
    return null;
  }

  static String? studentId(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your student ID.';
    if (!RegExp(r'^[A-Za-z0-9-]{4,}$').hasMatch(text)) {
      return 'Use letters, numbers, or dashes (at least 4 characters).';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'Please enter a valid email, like name@school.edu.';
    }
    return null;
  }

  /// Phone is optional: an empty value is fine.
  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!RegExp(r'^[0-9+\-\s()]{7,15}$').hasMatch(text)) {
      return 'Please enter a valid phone number, or leave it blank.';
    }
    return null;
  }
}
