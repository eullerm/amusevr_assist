import 'package:http/http.dart' as http;

class Response {
  final int statusCode;
  final String message;

  Response({required this.statusCode, required this.message});
}

class EspApi {
  static const String _baseUrl = 'http://amusevr';
  static const String _ssid = 'ssid';
  static const String _password = 'password';
  static const String _connectionType = 'connectionType';
  static const String _deviceKey = 'deviceKey';
  static const String _token = 'token';

  static Future<Response> connectToWifi(String ssid, String password, int connectionType, int? devicekey, String? token) async {
    Map body = {
      _ssid: ssid,
      _password: password,
      _connectionType: connectionType,
    };

    if (token != null) {
      body[_token] = token;
      if (devicekey != null) {
        body[_deviceKey] = devicekey;
      }
    }

    try {
      String message = '';
      final response = await http.post(
        Uri.parse('$_baseUrl/wifi'),
        body: body,
      );
      if (response.statusCode == 200) {
        message = 'Sucesso';
      } else {
        message = 'Falha';
      }
      return Response(statusCode: response.statusCode, message: message);
    } catch (e) {
      rethrow;
    }
  }
}
