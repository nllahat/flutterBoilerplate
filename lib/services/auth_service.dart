import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './user_service.dart';
import '../models/user_model.dart';
import '../models/firebase_exception.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  NoUser
}

class AuthService {
  final UserService userService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService({@required this.userService});

  // create user obj based on firebase user
  Future<Status> _authStatusFromFirebaseUser(FirebaseUser user) async {
    if (user == null) {
      return Status.Unauthenticated;
    }

    User appUser = await userService.getUser(user.uid);

    if (appUser == null) {
      return Status.NoUser;
    } else {
      return Status.Authenticated;
    }
  }

  // auth change user stream
  Stream<Status> get status {
    return _auth.onAuthStateChanged.asyncMap(this._authStatusFromFirebaseUser);
  }

  // sign in anon
  Future<void> signInAnon() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      throw new FirebaseException(e);
    }
  }

  // sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      throw new FirebaseException(error);
    }
  }

  // register with email and password
  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error.toString());
    }
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

  // sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      throw new FirebaseException(error);
    }
  }
}
