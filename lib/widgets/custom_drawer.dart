import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function() logoutFunction;
  final Function() homeFunction;
  final Function() espPageFunction;
  final Function() moodoPageFunction;

  final bool isLogged;
  final String actualPage;
  const CustomDrawer({
    Key? key,
    required this.logoutFunction,
    required this.homeFunction,
    required this.moodoPageFunction,
    required this.espPageFunction,
    required this.isLogged,
    required this.actualPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: const UserAccountsDrawerHeader(
        accountName: Text("AmuseVR Assist"),
        accountEmail: Text(""),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Wrap(
        runSpacing: 16,
        children: [
          button(
            text: 'Home',
            unselectedIcon: Icons.home_outlined,
            selectedIcon: Icons.home,
            function: homeFunction,
            isSelected: actualPage.toUpperCase() == 'HOMEPAGE',
          ),
          button(
            text: 'ESP WiFi',
            unselectedIcon: Icons.wifi_outlined,
            selectedIcon: Icons.wifi,
            function: espPageFunction,
            isSelected: actualPage.toUpperCase() == 'ESPSETTINGSPAGE',
          ),
          Visibility(
            visible: isLogged,
            child: button(
              text: 'Moodo',
              unselectedIcon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              function: moodoPageFunction,
              isSelected: actualPage.toUpperCase() == 'MOODOSETTINGSPAGE',
            ),
          ),
          const Divider(color: Colors.black54),
          Visibility(
            visible: isLogged,
            child: button(
              text: 'Logout',
              unselectedIcon: Icons.logout_outlined,
              selectedIcon: Icons.logout,
              function: logoutFunction,
              isSelected: actualPage.toUpperCase() == 'LOGOUT',
            ),
          ),
        ],
      ),
    );
  }

  Widget button(
      {required String text,
      required IconData unselectedIcon,
      required IconData selectedIcon,
      required Function() function,
      required bool isSelected}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: ListTile(
        leading: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color: isSelected ? Colors.white : Colors.black,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        onTap: isSelected
            ? null
            : () {
                function();
              },
      ),
    );
  }
}
