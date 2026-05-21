import 'package:firebase_auth/firebase_auth.dart';

class AppException {
  static String fromException(Object e) {
    if (e is FirebaseAuthException) {
      return _fromAuthCode(e.code);
    }
    if (e is FirebaseException) {
      return _fromFirestoreCode(e.code);
    }

    final raw = e.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }

  static String _fromAuthCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account with this email already exists. Please sign in.';
      case 'operation-not-allowed':
        return 'Sign-in with email and password is not enabled.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'requires-recent-login':
        return 'Please sign out and sign back in to perform this action.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  static String _fromFirestoreCode(String code) {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'The service is temporarily unavailable. Please try again.';
      case 'not-found':
        return 'The requested data was not found.';
      case 'already-exists':
        return 'This record already exists.';
      case 'resource-exhausted':
        return 'Service limit reached. Please try again later.';
      case 'deadline-exceeded':
        return 'The request timed out. Please check your connection.';
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'data-loss':
        return 'Data could not be retrieved. Please try again.';
      case 'unauthenticated':
        return 'You must be signed in to perform this action.';
      case 'failed-precondition':
        return 'Operation failed. Please try again.';
      case 'internal':
        return 'An internal server error occurred. Please try again later.';
      default:
        return 'A database error occurred. Please try again.';
    }
  }
}
