import 'package:flutter/material.dart';

import './navigation/tab_navigator_profile.dart';
import './navigation/tab_navigator_home.dart';
import './navigation/bottom_navigation.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  TabItem currentTab = TabItem.home;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
    TabItem.explore: GlobalKey<NavigatorState>(),
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
          _buildOffstageNavigator(TabItem.explore),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
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
