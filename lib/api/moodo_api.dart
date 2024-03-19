import 'package:amusevr_assist/models/device.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Response {
  final int? statusCode;
  final String? token;
  final bool? accepted;
  final String? error;

  Response({required this.statusCode, this.token, this.accepted, this.error});
}

class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class MoodoApi {
  static const String _baseUrl = 'https://rest.moodo.co/api';
  static Map<String, String> headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  static const String _email = 'email';
  static const String _password = 'password';

  static Future<Response> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: headers,
        body: json.encode({
          _email: email,
          _password: password,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      return Response(
        statusCode: response.statusCode,
        token: responseData['token'],
        accepted: responseData['accepted'],
        error: responseData['error'],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return Response(statusCode: response.statusCode, accepted: true);
      } else {
        return Response(statusCode: response.statusCode, accepted: false, error: 'error');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Device>> fetchDevices(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/boxes'),
        headers: {
          ...headers,
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List devices = jsonData['boxes'];
        return devices.map((device) => Device.fromMap(device)).toList();
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }
}
