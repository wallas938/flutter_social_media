import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_project/features/authentication/domain/entities/app.user.dart';
import 'package:flutter_social_project/features/authentication/domain/repository/auth.repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // create a new user
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

// fetch user document from firestore
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

// create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // the newly created user is stored into the firestore database in users collection
      await firestore.collection("users").doc(user.uid).set(user.toJson());

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
  Future<AppUser?> getCurrentUser() async {
    // Get Current User
    final firebaseUser = firebaseAuth.currentUser;

    // no user logged in..
    if (firebaseUser == null) return null;

    /// fetch user document from firestore
    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(firebaseUser.uid).get();

// check if user doc exists
    if (!userDoc.exists) {
      return null;
    }

// user exists
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: userDoc['name'],
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
