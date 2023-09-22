import 'package:shared_preferences/shared_preferences.dart';

class MoodoManager {
  static const String _deviceKey = 'deviceKey';

  static Future<void> storeDevice(int deviceKey, SharedPreferences? prefs) async {
    await prefs?.setInt(_deviceKey, deviceKey);
  }

  static Future<int?> getDevice(SharedPreferences? prefs) async {
    return prefs?.getInt(_deviceKey);
  }

  static Future<void> removeDevice(SharedPreferences? prefs) async {
    await prefs?.remove(_deviceKey);
  }
}
