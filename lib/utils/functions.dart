import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void logout(BuildContext context) {
  context.read<User>().removeToken();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: HomePage.routeName),
      builder: (context) => const HomePage(),
    ),
  );
}

void showCustomSnackBar(BuildContext context, String message, String typeMessage) {
  Map<String, Color> colors = {
    'info': Colors.blueAccent,
    'error': Colors.redAccent,
    'success': Colors.lightGreen,
    'warning': Colors.orangeAccent,
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: colors[typeMessage],
      ),
    );
}
