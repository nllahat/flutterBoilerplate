import './router.dart';

import './screens/wrapper.dart';
import './services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>.value(value: AuthService()),
        ],
        child: Consumer<AuthService>(
          builder: (ctx, auth, _) => StreamProvider<User>.value(
            value: auth.user,
            child: MaterialApp(
              title: 'MyApp',
              theme: ThemeData(
                primaryColor: Color.fromRGBO(68, 79, 90, 1),
                accentColor: Colors.redAccent.shade100,
                backgroundColor: Color.fromRGBO(68, 79, 90, 1),
                primarySwatch: Colors.grey,
                fontFamily: 'Roboto',
                cursorColor: Colors.white70,
                dividerTheme: DividerThemeData(
                    color: Colors.white70, thickness: 0.8, space: 10.0),
                primaryTextTheme: ThemeData.dark().textTheme.copyWith(
                      title: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white70),
                      button: TextStyle(color: Colors.black),
                      subtitle: TextStyle(fontSize: 18, color: Colors.white70),
                      headline: TextStyle(fontSize: 16, color: Colors.white70),
                      display1: TextStyle(fontSize: 18, color: Colors.white70),
                      display2: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic),
                    ),
                accentTextTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      button: TextStyle(color: Colors.white70),
                      subtitle: TextStyle(fontSize: 18, color: Colors.black),
                    ),
              ),
              home: Wrapper(),
              onGenerateRoute: Router.generateRouteLogister,
              onUnknownRoute: (settings) => MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
