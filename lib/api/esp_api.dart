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

  static Future<Response> connectToWifi(String ssid, String password) async {
    try {
      String message = '';
      final response = await http.post(
        Uri.parse('$_baseUrl/wifi'),
        body: {
          _ssid: ssid,
          _password: password,
        },
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
