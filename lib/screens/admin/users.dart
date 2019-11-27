import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/user_model.dart';
import 'package:flutter_boilerplate/services/user_service.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  Users({Key key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    Future<List<User>> usersFuture = Provider.of<UserService>(context, listen: false).users;

  }
  @override
  Widget build(BuildContext context) {


    return FutureProvider.value(
        value: usersFuture,
        child: Consumer<List<User>>(
          builder: (context, users, _) {
            return ListView.builder(
                itemCount: users?.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new Text(users[index].id);
                });
          },
        ));
  }
}
