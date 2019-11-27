import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/screens/admin/users.dart';

class Admin extends StatelessWidget {
  static const routeName = '/admin';
  const Admin({Key key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
    textStyle() {
      return new TextStyle(color: Colors.white, fontSize: 30.0);
    }

    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Admin dashboard"),
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Users",
              ),
              new Tab(
                text: "Organizations",
              ),
              new Tab(
                text: "Activities",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            Users(),
            new Container(
              color: Colors.blueGrey,
              child: new Center(
                child: new Text(
                  "Second",
                  style: textStyle(),
                ),
              ),
            ),
            new Container(
              color: Colors.teal,
              child: new Center(
                child: new Text(
                  "Third",
                  style: textStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}