import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/screens/authenticate/register.dart';
import './screens/home_to_delete.dart';
import './screens/authenticate/login.dart';
import './screens/edit_record.dart';

class Router {
  static Route<dynamic> generateRouteLogister(RouteSettings settings) {
    switch (settings.name) {
      case Login.routeName:
        return MaterialPageRoute(builder: (_) => Login());
      case Register.routeName:
        return MaterialPageRoute(builder: (_) => Register());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }

  static Route<dynamic> generateRouteHome(RouteSettings settings) {
    switch (settings.name) {
      case Home.routeName:
        return MaterialPageRoute(builder: (_) => Home());
      case EditRecordScreen.routeName:
        return MaterialPageRoute(builder: (_) => EditRecordScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }

  static Route<dynamic> generateRouteProfile(RouteSettings settings) {
    switch (settings.name) {
      case Login.routeName:
        return MaterialPageRoute(builder: (_) => Login());
      case Register.routeName:
        return MaterialPageRoute(builder: (_) => Register());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
