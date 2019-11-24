
import '../services/auth_service.dart';
import '../app.dart';
import '../screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Status authStatus = Provider.of<Status>(context);

    switch (authStatus) {
      case Status.Unauthenticated:
        return Authenticate();
        break;
      case Status.NoUser:
        return Authenticate();
        break;
      case Status.Authenticated:
        return App();
        break;
      default:
        return Authenticate();
    }
  }
}
