import 'package:flutter/foundation.dart';

class MockAuthService extends ChangeNotifier {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  // Mock sign in
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation for demo
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@').first;
      notifyListeners();
    } else {
      throw 'Invalid email or password';
    }
  }

  // Mock sign up
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String shopName,
    required String phone,
    required String location,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation for demo
    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = name;
      notifyListeners();
    } else {
      throw 'Please fill all required fields correctly';
    }
  }

  // Mock sign out
  Future<void> signOut() async {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }

  // Mock reset password
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty || !email.contains('@')) {
      throw 'Please enter a valid email address';
    }
    // In a real app, this would send a reset email
  }

  // Mock change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (currentPassword.isEmpty || newPassword.length < 6) {
      throw 'Invalid password';
    }
    // In a real app, this would update the password
  }

  String get userDisplayName => _userName ?? _userEmail?.split('@').first ?? 'User';
}
