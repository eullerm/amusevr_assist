// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String? _token;
  int? _deviceKey;
  String? _email;
  String? _password;
  SharedPreferences? _prefs;
  User({token, deviceKey, email, password}) {
    _token = token;
    _deviceKey = deviceKey;
    _email = email;
    _password = password;
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  String? get token => _token;
  int? get deviceKey => _deviceKey;
  String? get email => _email;
  String? get password => _password;

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

  void setEmail(String email) {
    _email = email;
    _prefs!.setString('email', email);
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    _prefs!.setString('password', password);
    notifyListeners();
  }

  void removeUser() {
    _token = null;
    _email = null;
    _password = null;
    _prefs!.remove('token');
    _prefs!.remove('email');
    _prefs!.remove('password');
    notifyListeners();
  }

  void removeDeviceKey() {
    _deviceKey = null;
    _prefs!.remove('deviceKey');
    notifyListeners();
  }
}
