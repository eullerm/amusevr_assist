import 'dart:async';

import 'package:amusevr_assist/api/esp_api.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/access_point_tile.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

class EspSettingsPage extends StatefulWidget {
  const EspSettingsPage({
    super.key,
  });

  @override
  State<EspSettingsPage> createState() => _EspSettingsPageState();
}

class _EspSettingsPageState extends State<EspSettingsPage> {
  List<WiFiAccessPoint> wifiList = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  String ssid = '';
  String password = '';
  String wpa = '';
  TextEditingController _textControllerPassword = TextEditingController();
  bool isObscure = true;
  int step = 0;
  late User user;

  RegExp regexWPA = RegExp(r'\bWPA\b', caseSensitive: false);
  RegExp regexWPA2 = RegExp(r'\bWPA2\b', caseSensitive: false);
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
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

    EspApi.connectToWifi(ssid, _textControllerPassword.text, typeWPA).then((response) {
      if (response.statusCode == 200) {
        showCustomSnackBar(context, 'Conectado com sucesso!', 'success');
        setState(() {
          step = 0; // Volta para tela de escolher rede
        });
      } else {
        showCustomSnackBar(context, 'Falha ao se conectar! Tente novamente.', 'error');
        setState(() {
          step = 1; // Volta para tela de digitar senha
        });
      }
    });
  }

  Widget listWifi() {
    return wifiList.isEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: const [
                Icon(Icons.warning_amber_rounded, size: 100, color: Colors.orangeAccent),
                Text("Nenhuma rede encontada!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Verifique se o aplicativo possui a permissão necessária e tente novamente.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: wifiList.length,
            itemBuilder: (context, index) {
              final network = wifiList[index];
              return AccessPointTile(
                onConfirm: () => {setWifi(network.ssid, network.capabilities)},
                accessPoint: network,
              );
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
    context.watch<User>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('AMUSEVR Assist'),
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
        drawer: CustomDrawer(
          isLogged: user.token != null,
          actualPage: 'espSettingsPage',
          homeFunction: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          espPageFunction: () {
            Navigator.pop(context);
          },
          logoutFunction: () {
            logout(context);
          },
          moodoPageFunction: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MoodoSettingsPage()),
            );
          },
        ));
  }
}