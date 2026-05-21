import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';
import '../core/app_exception.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;
  bool _isLoading = true;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AuthProvider() {
    _authRepository.authStateChanges.listen((User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _error = null;
    try {
      await _authRepository.signIn(email, password);
    } catch (e) {
      _error = AppException.fromException(e);
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    _error = null;
    try {
      await _authRepository.signUp(email, password);
      await _authRepository.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser?.reload();
      _user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      _error = AppException.fromException(e);
    }
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    _error = null;
    try {
      await _authRepository.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser?.reload();
      _user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      _error = AppException.fromException(e);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _error = null;
    try {
      await _authRepository.signOut();
    } catch (e) {
      _error = AppException.fromException(e);
    }
    notifyListeners();
  }
}
