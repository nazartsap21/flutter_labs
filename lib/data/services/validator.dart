class Validator {
  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Name cannot contain numbers';
    }
    return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateStationName(String value) {
    if (value.isEmpty) {
      return 'Station name cannot be empty';
    }
    return null;
  }

  static String? validateLocation(String value) {
    if (value.isEmpty) {
      return 'Location cannot be empty';
    }
    return null;
  }
}
