import 'package:flutter/services.dart';

class FirebaseException implements Exception {
  String code;
  String message;

  FirebaseException(PlatformException error) {
    this.code = error.code;
    this.message = error.message;
  }

  String getHumanReadableMessage() {
    switch (code) {
      case 'ERROR_INVALID_EMAIL':
        return 'Invalid email address';
      case 'ERROR_WRONG_PASSWORD':
        return 'Wrong password';
      case 'ERROR_USER_NOT_FOUND':
        return 'User not found';
      case 'ERROR_USER_DISABLED':
        return 'User is disabled';
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'Too many sign in attempts';
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return 'Sign in method is not allowed';
      case 'ERROR_INVALID_CREDENTIAL':
        return 'Credential data is malformed or has expired';
      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return 'An account with the email address already asserted to google';
        break;
      default:
        return message;
    }
  }

  @override
  String toString() {
    return message;
  }
}
