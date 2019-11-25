import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/screens/authenticate/logister.dart';
import 'package:flutter_boilerplate/screens/profile/extra_info.dart';

import '../services/auth_service.dart';
import '../app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Widget _getScreen(Status status) {
    switch (status) {
      case Status.Unauthenticated:
        return Logister();
        break;
      case Status.NoUser:
        return ExtraInfo();
        break;
      case Status.Authenticated:
        return App();
        break;
      default:
        return Logister();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);

    return StreamProvider<FirebaseUser>.value(
      value: authService.firebaseUser,
      child: Consumer<FirebaseUser>(
        builder: (context, firebaseUser, child) {
          return FutureProvider<Status>.value(
            value: authService.authStatusFromFirebaseUser(firebaseUser),
            child: Consumer<Status>(
              builder: (context, status, child) => _getScreen(status),
            ),
          );
        },
      ),
    );
  }
}
