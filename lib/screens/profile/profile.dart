import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/services/auth_service.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  static const routeName = '/profile';
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
                child: Container(
                  child: FlatButton(
                    child: Text('LOGOUT'),
                    onPressed: () {
                      Provider.of<AuthService>(context).signOut();
                    },
                  ),
                ),
              )),
    );
  }
}