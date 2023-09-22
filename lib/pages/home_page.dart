import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/login_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/pages/settings_esp_page.dart';
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
        title: const Text("AMUSEVR Assist"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: user.token == null,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text("Logar com a conta Moodo"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EspSettingsPage()),
                );
              },
              child: const Text("Selecionar WiFi"),
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
}
