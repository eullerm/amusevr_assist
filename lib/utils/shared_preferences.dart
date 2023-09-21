import 'package:amusevr_assist/utils/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  SharedPreferences? _prefs;

  SharedPreferencesProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> storeToken(String token) async {
    await TokenManager.storeToken(token, _prefs);
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await TokenManager.getToken(_prefs);
  }

  Future<void> removeToken() async {
    await TokenManager.removeToken(_prefs);
    notifyListeners();
  }
}
