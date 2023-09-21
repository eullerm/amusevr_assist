import 'package:amusevr_assist/pages/login_page.dart';
import 'package:amusevr_assist/pages/settings_esp_page.dart';
import 'package:amusevr_assist/utils/shared_preferences.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userToken = "";
  late SharedPreferencesProvider _prefsProvider;
  @override
  void initState() {
    _prefsProvider = Provider.of<SharedPreferencesProvider>(context, listen: false);
    super.initState();
  }

  getUserToken() async {
    userToken = await _prefsProvider.getToken() ?? "";
    setState(() async {});
    print('userToken: $userToken');
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SharedPreferencesProvider>();
    getUserToken();

    return Scaffold(
      appBar: AppBar(
        title: Text("AMUSEVR Assist"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Logar com a conta Moodo"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsEspPage()),
                );
              },
              child: Text("Configurar o ESP"),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        isLogged: userToken.isNotEmpty,
        homeFunction: () {
          Navigator.pop(context);
        },
        logoutFunction: logout,
      ),
    );
  }

  logout() {
    setState(() {
      userToken = "";
      _prefsProvider.removeToken();
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
