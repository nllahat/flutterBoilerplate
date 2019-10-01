import 'package:flutter/material.dart';

import '../router.dart';
import './bottom_navigation.dart';

class TabNavigatorProfile extends StatelessWidget {
  TabNavigatorProfile({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: Router.generateRouteProfile,
        onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
            ));
  }
}
