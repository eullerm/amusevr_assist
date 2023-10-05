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
  static const String _email = 'email';
  static const String _emailPassword = 'emailPassword';

  static Future<Response> connectToWifi(
    String ssid,
    String password,
    int connectionType,
    int? devicekey,
    String? token,
    String? email,
    String? emailPassword,
  ) async {
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
      if (email != null) {
        body[_email] = email;
        body[_emailPassword] = emailPassword;
      }
    }

    try {
      String message = '';
      final response = await http.post(
        Uri.parse('$_baseUrl/wifi'),
        body: body,
      );
      print(response.toString());
      if (response.statusCode == 200) {
        message = 'Sucesso';
      } else {
        message = 'Falha';
      }

      return Response(statusCode: response.statusCode, message: message);
    } catch (e) {
      return Response(statusCode: 404, message: 'Falha ao se conectar! Verifique se você está conectado no ESP.');
    }
  }
}
