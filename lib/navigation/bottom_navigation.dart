import 'package:flutter/material.dart';

enum TabItem { home, profile, explore }

class TabHelper {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.home;
      case 1:
        return TabItem.profile;
      case 2:
        return TabItem.explore;
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
      case TabItem.explore:
        return 'Explore';
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
      case TabItem.explore:
        return Icons.explore;
      default:
        return Icons.person;
    }
  }

  static Color color(TabItem tabItem) {
    return Colors.black;
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.home),
        _buildItem(tabItem: TabItem.profile),
        _buildItem(tabItem: TabItem.explore),
      ],
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
