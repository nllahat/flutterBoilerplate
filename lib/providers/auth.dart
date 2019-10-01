import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/firebase_exception.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  SignUp,
}

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Auth() {
    getCurrentUser().then((FirebaseUser firebaseUser) {
      _onAuthStateChanged(firebaseUser);
    }).catchError((error) => throw error);
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  AuthStatus _authStatus = AuthStatus.Uninitialized;
  FirebaseUser _user;

  FirebaseUser get user {
    return _user;
  }

  AuthStatus get authStauts {
    return _authStatus;
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _authStatus = AuthStatus.Unauthenticated;
    } else {
      _user = firebaseUser;
      _authStatus = AuthStatus.Authenticated;
    }

    notifyListeners();
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (error) {
      throw new FirebaseException(error);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      throw new FirebaseException(error);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user = null;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
