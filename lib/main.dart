import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/services/user_service.dart';

import './router.dart';

import './screens/wrapper.dart';
import './services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<UserService>.value(value: UserService()),
          ProxyProvider<UserService, AuthService>(
            builder: (ctx, userService, _) =>
                AuthService(userService: userService),
          ),
        ],
        child: MaterialApp(
          title: 'forward',
          home: Wrapper(),
          onGenerateRoute: Router.generateRouteLogister,
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
          ),
        ));
  }
}
