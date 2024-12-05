// auth_presenter.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:northstars_final/models/auth_page_model.dart';

abstract class AuthViewContract {
  void showError(String message);
  void navigateToHome();
}

class AuthPresenter {
  final AuthModel _authModel;
  final AuthViewContract _view;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthPresenter(this._view) : _authModel = AuthModel();

  Future<void> login(String email, String password) async {
    try {
      await _authModel.signIn(email, password);
      _view.navigateToHome();
    } on FirebaseAuthException catch (e) {
      _view.showError(e.message ?? "Authentication failed.");
    }
  }


  Future<void> signUp(String email, String password) async {
    try {
      await _authModel.signUp(email, password);
      _view.navigateToHome();
    } catch (e) {
      _view.showError(e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      // Sign out previous session (force account selection)
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the sign-in is successful, authenticate with Firebase
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credentials
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Delegate saving the user to the model
        await _authModel.saveUserToFirestore(userCredential.user);

        // Navigate to the home page after successful sign-in
        _view.navigateToHome();
      }
    } catch (e) {
      _view.showError(e.toString());
    }
  }
}
