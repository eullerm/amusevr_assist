import 'dart:async';

import 'package:amusevr_assist/api/esp_api.dart';
import 'package:amusevr_assist/widgets/access_point_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

class SettingsEspPage extends StatefulWidget {
  const SettingsEspPage({
    super.key,
  });

  @override
  State<SettingsEspPage> createState() => _SettingsEspPageState();
}

class _SettingsEspPageState extends State<SettingsEspPage> {
  List<WiFiAccessPoint> wifiList = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  String ssid = '';
  String password = '';
  String wpa = '';
  TextEditingController _textControllerPassword = TextEditingController();
  bool isObscure = true;
  int step = 0;

  RegExp regexWPA = RegExp(r'\bWPA\b', caseSensitive: false);
  RegExp regexWPA2 = RegExp(r'\bWPA2\b', caseSensitive: false);
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

  void setWifi(String newSSID, String newWPA) {
    setState(() {
      ssid = newSSID;
      wpa = newWPA;
      step = 1;
    });
  }

  void onConnect() async {
    setState(() {
      step = 2; // Vai para tela de loading
    });

    late int typeWPA;

    if (regexWPA2.hasMatch(wpa)) {
      typeWPA = 2;
    } else if (regexWPA.hasMatch(wpa)) {
      typeWPA = 1;
    }

    final Response response = await EspApi.connectToWifi(ssid, _textControllerPassword.text, typeWPA);

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
              return AccessPointTile(onConfirm: () => {setWifi(network.ssid, network.capabilities)}, accessPoint: network);
            },
          );
  }

  Widget confirmConnection() {
    return Column(
      children: [
        Text(
          ssid,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  step = 0;
                });
              },
              child: const Text('Voltar'),
            ),
            ElevatedButton(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(
          builder: (BuildContext context) {
            switch (step) {
              case 0:
                return listWifi();
              case 1:
                return confirmConnection();
              case 2:
                return const Center(
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
