import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  int? deviceKey = prefs.getInt('deviceKey');
  print('token: $token');
  print('deviceKey: $deviceKey');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => User(token: token, deviceKey: deviceKey),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmuseVR Assist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}
