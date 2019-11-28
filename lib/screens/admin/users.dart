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
  List<User> _users;
  @override
  void initState() {
    Provider.of<UserService>(context, listen: false).users.then((users) {
      _users = users;
    }).catchError((error) {
      print(error);
    });

    super.initState();
  }

  Color _getIconColorByRole(Role role) {
    switch (role) {
      case Role.Admin:
        return Colors.black;
      case Role.Coordinator:
        return Colors.orangeAccent;
      case Role.Regular:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _users?.length,
        itemBuilder: (BuildContext ctxt, int index) {
          var user = _users?.elementAt(index);
          return ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 40.0,
                  color: _getIconColorByRole(user?.role),
                ),
              ],
            ),
            title: Text(user?.fullName ?? ''),
            subtitle:
                Text(user?.role?.toString()?.split('.')?.elementAt(1) ?? ''),
          );
        });
  }
}
