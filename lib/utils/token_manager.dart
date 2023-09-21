import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'token';

  static Future<void> storeToken(String token, SharedPreferences? prefs) async {
    await prefs?.setString(_tokenKey, token);
  }

  static Future<String?> getToken(SharedPreferences? prefs) async {
    return prefs?.getString(_tokenKey);
  }

  static Future<void> removeToken(SharedPreferences? prefs) async {
    await prefs?.remove(_tokenKey);
  }
}
