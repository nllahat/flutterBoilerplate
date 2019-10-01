import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './app.dart';
import './screens/login.dart';
import './router.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getPageByAuthState(AuthStatus currentAuthStatus) {
    switch (currentAuthStatus) {
      case AuthStatus.Uninitialized:
      case AuthStatus.Unauthenticated:
        return Login();
      case AuthStatus.SignUp:
        return Container(child: Text('SignUp Page'));
      case AuthStatus.Authenticated:
        return App();
      default:
        return Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        /*ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders,
              ),
        ), */
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
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
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            buttonTheme: ButtonTheme(
              minWidth: 200.0,
              height: 40.0,
              buttonColor: Color.fromRGBO(255, 255, 255, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textTheme: ButtonTextTheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            ).data,
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
          routes: {
            '/': (_) => _getPageByAuthState(auth.authStauts),
          },
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
    );
  }
}
