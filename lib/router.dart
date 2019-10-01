import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/screens/home.dart';
import './screens/login.dart';

class Router {
  static Route<dynamic> generateRouteLogister(RouteSettings settings) {
    switch (settings.name) {
      case Login.routeName:
        return MaterialPageRoute(builder: (_) => Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => Container(child: Text('Signup Page'),));
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
      case '/signup':
        return MaterialPageRoute(builder: (_) => Container(child: Text('Signup Page'),));
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
