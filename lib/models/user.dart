// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String? _tokenMoodo;
  int? _deviceKey;
  String? _name;
  String? _email;
  String? _password;
  String? _espIpAddress;
  SharedPreferences? _prefs;
  bool _isAuthenticated = false;
  bool? _firstLogin;

  User({
    tokenMoodo,
    deviceKey,
    name,
    email,
    password,
    espIpAddress,
    isAuthenticated,
    firstLogin,
  }) {
    _tokenMoodo = tokenMoodo;
    _deviceKey = deviceKey;
    _name = name;
    _email = email;
    _password = password;
    _espIpAddress = espIpAddress;
    _isAuthenticated = isAuthenticated;
    _firstLogin = firstLogin;
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  String? get tokenMoodo => _tokenMoodo;
  int? get deviceKey => _deviceKey;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  String? get espIpAddress => _espIpAddress;
  bool get isAuthenticated => _isAuthenticated;
  bool? get firstLogin => _firstLogin;

  void setIsAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    _prefs!.setBool('isAuthenticated', isAuthenticated);
    notifyListeners();
  }

  void setTokenMoodo(String token) {
    _tokenMoodo = token;
    _prefs!.setString('tokenMoodo', token);
    notifyListeners();
  }

  void setDeviceKey(int deviceKey) {
    _deviceKey = deviceKey;
    _prefs!.setInt('deviceKey', deviceKey);
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    _prefs!.setString('name', name);
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

  void setEspIpAddress(String espIpAddress) {
    _espIpAddress = espIpAddress;
    _prefs!.setString('espIpAddress', espIpAddress);
    notifyListeners();
  }

  void removeUser() {
    _tokenMoodo = null;
    _isAuthenticated = false;
    _email = null;
    _password = null;
    _espIpAddress = null;
    _prefs!.remove('tokenMoodo');
    _prefs!.remove('name');
    _prefs!.remove('email');
    _prefs!.remove('password');
    _prefs!.remove('espIpAddress');
    _prefs!.remove('deviceKey');
    _prefs!.remove('isAuthenticated');
    notifyListeners();
  }

  void removeDeviceKey() {
    _deviceKey = null;
    _prefs!.remove('deviceKey');
    notifyListeners();
  }

  void unlinkMoodoAccount() {
    _deviceKey = null;
    _tokenMoodo = null;
    _prefs!.remove('deviceKey');
    _prefs!.remove('tokenMoodo');
    notifyListeners();
  }
}
