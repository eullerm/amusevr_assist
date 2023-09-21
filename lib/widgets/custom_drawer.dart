import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function logoutFunction;
  final Function homeFunction;
  final bool isLogged;
  const CustomDrawer({
    Key? key,
    required this.logoutFunction,
    required this.homeFunction,
    required this.isLogged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              homeFunction();
            },
          ),
          Visibility(
            visible: isLogged,
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Moodo Settings"),
              onTap: () {},
            ),
          ),
          const Divider(color: Colors.black54),
          Visibility(
            visible: isLogged,
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                logoutFunction();
              },
            ),
          ),
        ],
      ),
    );
  }
}
