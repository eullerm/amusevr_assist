import 'dart:ui';

import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/login_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  @override
  void initState() {
    user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("AmuseVR Assist"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            button(
              text: "Logar com a conta Moodo",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              visible: user.token == null,
            ),
            button(
              text: "Selecionar WiFi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EspSettingsPage()),
                );
              },
            ),
            button(
              text: "Moodo",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoodoSettingsPage()),
                );
              },
              visible: user.token != null,
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        isLogged: user.token != null,
        actualPage: 'homePage',
        homeFunction: () {
          Navigator.pop(context);
        },
        espPageFunction: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EspSettingsPage()),
          );
        },
        logoutFunction: () {
          logout(context);
        },
        moodoPageFunction: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MoodoSettingsPage()),
          );
        },
      ),
    );
  }

  Widget button({required String text, required Function() onTap, bool visible = true}) {
    return Visibility(
      visible: visible,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: MediaQuery.of(context).size.width / 2 - 64,
        height: MediaQuery.of(context).size.width / 2 - 64,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.lightBlueAccent.withOpacity(0.4)),
            ),
            onPressed: () {
              onTap();
            },
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
