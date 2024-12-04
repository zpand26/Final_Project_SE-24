// auth_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthModel({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed.");
    }
  }


  Future<UserCredential> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });


    return userCredential;
  }

  Future<void> saveUserToFirestore(User? user) async {
    try {
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);

        final userExists = await userDoc.get().then((doc) => doc.exists);

        if (!userExists) {
          await userDoc.set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName ?? 'Anonymous',
            'photoURL': user.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to save user to Firestore: $e");
    }
  }

}

