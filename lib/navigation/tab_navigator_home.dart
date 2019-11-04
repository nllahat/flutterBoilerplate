import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/providers/artists_provider.dart';
import 'package:flutter_boilerplate/providers/auth.dart';
import 'package:provider/provider.dart';

import '../router.dart';
import './bottom_navigation.dart';
import '../providers/records_provider.dart';

class TabNavigatorHome extends StatelessWidget {
  TabNavigatorHome({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<Auth, RecordsProvider>(
          builder: (ctx, auth, previousRecords) => RecordsProvider(
            previousRecords == null ? [] : previousRecords.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ArtistsProvider>(
          builder: (ctx, auth, previousArtists) => ArtistsProvider(
            previousArtists == null ? [] : previousArtists.items,
          ),
        ),
      ],
      child: Navigator(
          key: navigatorKey,
          initialRoute: '/home',
          onGenerateRoute: Router.generateRouteHome,
          onUnknownRoute: (settings) => MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              )),
    );
  }
}
