import 'package:http/http.dart' as http;

class Response {
  final int statusCode;
  final String message;

  Response({required this.statusCode, required this.message});
}

class EspApi {
  static const String _baseUrl = 'http://10.1.1.1';
  static const String _ssid = 'ssid';
  static const String _password = 'password';
  static const String _connectionType = 'connectionType';
  static const String _deviceKey = 'deviceKey';
  static const String _token = 'token';

  static Future<Response> connectToWifi(
    String ssid,
    String password,
    String connectionType,
    String? devicekey,
    String? token,
  ) async {
    Map<String, String> queryParams = {
      _ssid: ssid,
      _password: password,
      _connectionType: connectionType,
    };

    if (token != null) {
      queryParams[_token] = token;
      if (devicekey != null) {
        queryParams[_deviceKey] = devicekey;
      }
    }

    try {
      String message = '';
      String queryString = Uri(queryParameters: queryParams).query;
      final response = await http.post(
        Uri.parse('$_baseUrl/wifi?$queryString'),
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
