import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? _token;
  int? _deviceKey;

  String? get token => _token;
  int? get deviceKey => _deviceKey;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setDeviceKey(int deviceKey) {
    _deviceKey = deviceKey;
    notifyListeners();
  }

  void removeToken() {
    _token = null;
    notifyListeners();
  }

  void removeDeviceKey() {
    _deviceKey = null;
    notifyListeners();
  }
}
