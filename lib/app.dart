import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/navigation/tab_navigator_admin.dart';
import 'package:provider/provider.dart';

import './navigation/tab_navigator_profile.dart';
import './navigation/tab_navigator_home.dart';
import './navigation/bottom_navigation.dart';
import 'models/user_model.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  TabItem currentTab = TabItem.home;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
    // TabItem.admin: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(TabItem.home),
            _buildOffstageNavigator(TabItem.profile),
            Consumer<User>(
              builder: (context, user, _) {
                if (user != null && user.role == Role.Admin) {
                  return _buildOffstageNavigator(TabItem.admin);
                } else {
                  return Container();
                }
              },
            )
          ]),
          bottomNavigationBar: Consumer<User>(
            builder: (context, user, _) {
              return BottomNavigation(
                currentTab: currentTab,
                onSelectTab: _selectTab,
                userRole: user == null ? null : user.role,
              );
            },
          )),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.home:
        return Offstage(
          offstage: currentTab != tabItem,
          child: TabNavigatorHome(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
        break;
      case TabItem.profile:
        return Offstage(
          offstage: currentTab != tabItem,
          child: TabNavigatorProfile(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
        break;
      case TabItem.admin:
        return Offstage(
          offstage: currentTab != tabItem,
          child: TabNavigatorAdmin(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
        break;
      default:
        return Offstage(
            offstage: currentTab != tabItem,
            child: TabNavigatorHome(
              navigatorKey: navigatorKeys[tabItem],
              tabItem: tabItem,
            ));
    }
  }
}
