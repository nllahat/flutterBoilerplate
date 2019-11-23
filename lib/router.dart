import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/screens/authenticate/register.dart';
import 'package:flutter_boilerplate/screens/organizations/edit_organization.dart';
import './screens/home.dart';
import './screens/authenticate/login.dart';
import './screens/activities/edit_activity.dart';

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
      case EditActivity.routeName:
        return MaterialPageRoute(builder: (_) => EditActivity());
      case EditOrganization.routeName:
        return MaterialPageRoute(builder: (_) => EditOrganization());
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
