import 'dart:io';

import 'package:amusevr_assist/api/firebase_api.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApi.initialize();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tokenMoodo = prefs.getString('tokenMoodo');
  int? deviceKey = prefs.getInt('deviceKey');
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');
  bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => User(
          tokenMoodo: tokenMoodo,
          deviceKey: deviceKey,
          email: email,
          password: password,
          isAuthenticated: isAuthenticated,
        ),
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
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
