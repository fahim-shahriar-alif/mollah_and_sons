import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService extends ChangeNotifier {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  String? get userEmail => _auth.currentUser?.email;
  String? get userName => _auth.currentUser?.displayName;

  // Initialize auth state listener
  void initialize() {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String shopName,
    required String phone,
    required String location,
  }) async {
    try {
      // Create user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Store additional user data in Firestore
      print('DEBUG: Storing user data for UID: ${userCredential.user?.uid}');
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email.trim(),
        'shopName': shopName,
        'phone': phone,
        'location': location,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('DEBUG: User data stored successfully');

    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw 'No user logged in';

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Get user display name
  String get userDisplayName {
    User? user = _auth.currentUser;
    return user?.displayName ?? user?.email?.split('@').first ?? 'User';
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print('DEBUG: No current user found');
        return null;
      }

      print('DEBUG: Fetching user data for UID: ${user.uid}');
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!doc.exists) {
        print('DEBUG: User document does not exist in Firestore');
        // Try to create basic user data from Firebase Auth
        await _createUserDataFromAuth();
        // Retry fetching
        doc = await _firestore.collection('users').doc(user.uid).get();
      }
      
      final userData = doc.data() as Map<String, dynamic>?;
      print('DEBUG: Retrieved user data: $userData');
      return userData;
    } catch (e) {
      print('DEBUG: Error fetching user data: $e');
      return null;
    }
  }

  // Create user data from Firebase Auth if Firestore document is missing
  Future<void> _createUserDataFromAuth() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      print('DEBUG: Creating user data from Firebase Auth');
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? user.email?.split('@').first ?? 'User',
        'email': user.email ?? '',
        'shopName': 'Your Shop',
        'phone': 'Not provided',
        'location': 'Not provided',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('DEBUG: User data created from Firebase Auth');
    } catch (e) {
      print('DEBUG: Error creating user data from auth: $e');
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData({
    required String name,
    required String shopName,
    required String phone,
    required String location,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw 'No user logged in';

      print('DEBUG: Updating user data for UID: ${user.uid}');
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'shopName': shopName,
        'phone': phone,
        'location': location,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Also update Firebase Auth display name
      await user.updateDisplayName(name);
      print('DEBUG: User data updated successfully');
    } catch (e) {
      print('DEBUG: Error updating user data: $e');
      throw 'Failed to update profile. Please try again.';
    }
  }

  // Helper method to convert Firebase auth errors to user-friendly messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'requires-recent-login':
        return 'Please log out and log back in to perform this action.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
