import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/user_model.dart';

enum TabItem { home, profile, admin }

class TabHelper {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.home;
      case 1:
        return TabItem.profile;
      case 2:
        return TabItem.admin;
      default:
        return TabItem.home;
    }
  }

  static String description(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.home:
        return 'Home';
      case TabItem.profile:
        return 'Profile';
      case TabItem.admin:
        return 'Admin';
      default:
        return 'Home';
    }
  }

  static IconData icon(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.home:
        return Icons.home;
      case TabItem.profile:
        return Icons.person;
      case TabItem.admin:
        return Icons.verified_user;
      default:
        return Icons.person;
    }
  }

  static Color color(TabItem tabItem) {
    return Colors.black;
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab, this.userRole});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Role userRole;

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();

    items.add(_buildItem(tabItem: TabItem.home));
    items.add(_buildItem(tabItem: TabItem.profile));

    if (userRole == Role.Admin) {
      items.add(_buildItem(tabItem: TabItem.admin));
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items,
      onTap: (index) => onSelectTab(
        TabHelper.item(index: index),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? TabHelper.color(item) : Colors.grey;
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = TabHelper.description(tabItem);
    IconData icon = TabHelper.icon(tabItem);

    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }
}
