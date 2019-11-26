import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  static const routeName = '/admin';
  const Admin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
                child: Container(
                  child: FlatButton(
                    child: Text('ADMIN'),
                    onPressed: () {
                      return;
                    },
                  ),
                ),
              )),
    );
  }
}