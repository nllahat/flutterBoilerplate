import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/organizations_service.dart';
import '../services/activities_service.dart';
import '../router.dart';
import './bottom_navigation.dart';

class TabNavigatorAdmin extends StatelessWidget {
  TabNavigatorAdmin({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<OrganizationService>.value(value: OrganizationService()),
          Provider<ActivitiesService>.value(value: ActivitiesService()),
        ],
        child: Navigator(
            key: navigatorKey,
            initialRoute: '/admin',
            onGenerateRoute: Router.generateRouteAdmin,
            onUnknownRoute: (settings) => MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
                )));
  }
}
