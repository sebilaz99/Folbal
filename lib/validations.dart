class Validations {
  static String? validateFullName(String fullName) {
    final name = fullName.trim().split(RegExp(r'\s+'));
    if (name.length < 2) {
      return "Please enter your full name";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }
}
