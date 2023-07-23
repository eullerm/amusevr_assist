import 'dart:async';

import 'package:amusevr_assist/api/esp_api.dart';
import 'package:amusevr_assist/widgets/access_point_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<WiFiAccessPoint> wifiList = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  String ssid = '';
  String password = '';
  TextEditingController _textControllerPassword = TextEditingController();
  bool isObscure = true;
  int step = 0;
  @override
  void initState() {
    super.initState();
    _startListeningToScannedResults();
  }

  @override
  dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void _startListeningToScannedResults() async {
    final can = await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        subscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
          setState(() => wifiList = results);
        });
        break;
      case CanGetScannedResults.notSupported:
        // TODO: Handle this case.
        break;
      case CanGetScannedResults.noLocationPermissionRequired:
        // TODO: Handle this case.
        break;
      case CanGetScannedResults.noLocationPermissionDenied:
        // TODO: Handle this case.
        break;
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        // TODO: Handle this case.
        break;
      case CanGetScannedResults.noLocationServiceDisabled:
        // TODO: Handle this case.
        break;
    }
  }

  void setWifiSSID(String newSSID) {
    setState(() {
      ssid = newSSID;
      step = 1;
    });
  }

  void onConnect() async {
    setState(() {
      step = 2; // Vai para tela de loading
    });

    final Response response = await EspApi.connectToWifi(ssid, _textControllerPassword.text);

    if (response.statusCode == 200) {
      // Show a success snackbar
      kShowSnackBar(context, 'Conectado com sucesso!');
      setState(() {
        step = 0; // Volta para tela de escolher rede
      });
    } else {
      // Show an error snackbar
      kShowSnackBar(context, 'Falha ao se conectar! Tente novamente.');
      setState(() {
        step = 1; // Volta para tela de digitar senha
      });
    }
  }

  Widget _buildInfo(String label, dynamic value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value.toString()))
        ],
      ),
    );
  }

  Widget listWifi() {
    return wifiList.isEmpty
        ? const Text("Nenhuma rede encontrada")
        : ListView.builder(
            itemCount: wifiList.length,
            itemBuilder: (context, index) {
              final network = wifiList[index];
              return AccessPointTile(onConfirm: () => {setWifiSSID(network.ssid)}, accessPoint: network);
            },
          );
  }

  Widget confirmConnection() {
    return Column(
      children: [
        Text(ssid),
        TextField(
          controller: _textControllerPassword,
          obscureText: isObscure,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Senha',
            suffixIcon: IconButton(
              icon: Icon(isObscure ? Icons.security : Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
            ),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  step = 0;
                });
              },
              child: const Text('Voltar'),
            ),
            TextButton(
              onPressed: () {
                onConnect();
              },
              child: const Text('Conectar'),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AmuseVR Assist'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          switch (step) {
            case 0:
              return listWifi();
            case 1:
              return confirmConnection();
            case 2:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              setState(() {
                step = 0;
              });
              return listWifi();
          }
        },
      ),
    );
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
