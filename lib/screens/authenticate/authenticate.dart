import 'package:flutter_boilerplate/services/auth_service.dart';
import 'package:provider/provider.dart';

import './register.dart';
import './login.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      child: showSignIn
          ? Login(toggleView: toggleView)
          : Register(toggleView: toggleView),
    );
  }
}
