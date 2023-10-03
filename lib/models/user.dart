// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String? _token;
  int? _deviceKey;
  SharedPreferences? _prefs;
  User({
    token,
    deviceKey,
  }) {
    _token = token;
    _deviceKey = deviceKey;
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  String? get token => _token;
  int? get deviceKey => _deviceKey;

  void setToken(String token) {
    _token = token;
    _prefs!.setString('token', token);
    notifyListeners();
  }

  void setDeviceKey(int deviceKey) {
    _deviceKey = deviceKey;
    _prefs!.setInt('deviceKey', deviceKey);
    notifyListeners();
  }

  void removeToken() {
    _token = null;
    _prefs!.remove('token');
    notifyListeners();
  }

  void removeDeviceKey() {
    _deviceKey = null;
    _prefs!.remove('deviceKey');
    notifyListeners();
  }
}
