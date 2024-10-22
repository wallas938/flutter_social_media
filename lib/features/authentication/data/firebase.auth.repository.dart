import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';
import 'package:flutter_social_project/features/authentication/domain/repository/auth.repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // create a new user
      final UserCredential userData = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // a new user is created for the app
      AppUser user = AppUser(uid: userData.user!.uid, name: name, email: email);

      // the newly created user is stored into the firestore database in users collection
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Signing failed $e');
    }
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userData = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(uid: userData.user!.uid, name: '', email: email);

      return user;
    } catch (e) {
      throw Exception('Login failed $e');
    }
  }

  @override
  AppUser? getCurrentUser() {
    // Get Current User
    final currentUser = firebaseAuth.currentUser;

    // no user logged in..
    if (currentUser == null) return null;

    return AppUser(uid: currentUser.uid, name: '', email: currentUser.email!);
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
