import 'dart:convert';

import 'package:http/http.dart' as http;

class Response {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? body;

  Response({required this.statusCode, required this.message, this.body});
}

class EspApi {
  static const String _baseUrl = 'http://10.1.1.1';
  static const String _ssid = 'ssid';
  static const String _password = 'password';

  static Future<Response> connectToWifi(
    String ssid,
    String password,
  ) async {
    Map<String, String> queryParams = {
      _ssid: ssid,
      _password: password,
    };

    try {
      String message = '';
      String queryString = Uri(queryParameters: queryParams).query;

      final response = await http.post(
        Uri.parse('$_baseUrl/wifi?$queryString'),
      );
      if (response.statusCode == 200) {
        message = 'Sucesso';
      } else {
        message = 'Falha';
      }

      return Response(statusCode: response.statusCode, message: message, body: jsonDecode(response.body));
    } catch (e) {
      return Response(statusCode: 404, message: 'Falha ao se conectar! Verifique se você está conectado no ESP.');
    }
  }
}
