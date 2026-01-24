/*

FIREBASE IS OUR BACKEND

*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  // access to firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      await user.delete();
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // attempt to sign in user with email and password
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // if sign in is successful, return app user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
      return user;
    } catch (e) {
      // if sign in fails, return null
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    // attempt sign up
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // if sign up is successful, return app user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
      return user;
    } catch (e) {
      // if sign up fails, return null
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent. Check your inbox.';
    } catch (e) {
      throw Exception('An error occured: $e');
    }
  }
}
