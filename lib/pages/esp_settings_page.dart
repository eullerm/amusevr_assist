import 'dart:async';

import 'package:amusevr_assist/api/esp_api.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/access_point_tile.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:amusevr_assist/widgets/password_field.dart';
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

class _EspSettingsPageState extends State<EspSettingsPage> with WidgetsBindingObserver {
  List<WiFiAccessPoint> wifiList = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  String ssid = '';
  String password = '';
  String wpa = '';
  final TextEditingController _textControllerPassword = TextEditingController();
  bool isObscure = true;
  int step = 0;
  String errorMessage = 'Verifique se o aplicativo possui a permissão necessária e tente novamente!';
  CanGetScannedResults? can;
  late User user;

  RegExp regexWPA = RegExp(r'\bWPA\b', caseSensitive: false);
  RegExp regexWPA2 = RegExp(r'\bWPA2\b', caseSensitive: false);
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    _startListeningToScannedResults();
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    subscription?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startListeningToScannedResults();
    }
  }

  void _startListeningToScannedResults() async {
    can = await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        subscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
          setState(() {
            wifiList = results;
          });
        });
        break;
      case CanGetScannedResults.notSupported:
        setState(() {
          errorMessage = "O aparelho não consegue listar os pontos de acesso WiFi!";
        });
        break;
      case CanGetScannedResults.noLocationPermissionRequired:
        setState(() {
          errorMessage = "O aplicativo precisa de permissão para listar os pontos de acesso WiFi!";
        });
        break;
      case CanGetScannedResults.noLocationPermissionDenied:
        setState(() {
          errorMessage =
              "O aplicativo precisa de permissão para listar os pontos de acesso WiFi!\nAtive a localização do celular e tente voltar a esta tela novamente!";
        });
        break;
      case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
        setState(() {
          errorMessage =
              "O GPS precisa de permissão mais precisa para listar os pontos de acesso WiFi!\nAtive a permissão do celular e tente voltar a esta tela novamente!";
        });
        break;
      case CanGetScannedResults.noLocationServiceDisabled:
        setState(() {
          errorMessage =
              "O GPS do celular precisa estar ligado para listar os pontos de acesso WiFi!\nAtive a localização do celular e tente voltar a esta tela  novamente!";
        });
        break;
      default:
        setState(() {
          errorMessage = can.toString();
        });
        showCustomSnackBar(context, can.toString(), 'error');
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

    late String typeWPA;

    if (regexWPA2.hasMatch(wpa)) {
      typeWPA = '2';
    } else if (regexWPA.hasMatch(wpa)) {
      typeWPA = '1';
    }

    try {
      EspApi.connectToWifi(ssid, _textControllerPassword.text, typeWPA, user.deviceKey as String, user.token).then((response) {
        if (response.statusCode == 200) {
          showCustomSnackBar(context, 'Conectado com sucesso!', 'success');
          setState(() {
            step = 0; // Volta para tela de escolher rede
          });
        } else if (response.statusCode == 404) {
          showCustomSnackBar(context, response.message, 'error');
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
    } catch (e) {
      showCustomSnackBar(context, 'Falha ao se conectar! Tente novamente.', 'error');
      setState(() {
        step = 1; // Volta para tela de digitar senha
      });
    }
  }

  Widget listWifi() {
    ScrollController listViewController = ScrollController();
    return wifiList.isEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.orangeAccent),
                const Text(
                  "Nenhuma rede encontada!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Lembre-se de se conectar na rede WiFi do ESP antes de selecionar a rede que ele se conectará!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: wifiList.length,
                  controller: listViewController,
                  itemBuilder: (context, index) {
                    final network = wifiList[index];
                    return AccessPointTile(
                      onConfirm: () => {setWifi(network.ssid, network.capabilities)},
                      accessPoint: network,
                    );
                  },
                ),
              ],
            ),
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
        PasswordField(
          passwordController: _textControllerPassword,
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
        title: const Text('AmuseVR Assist'),
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
      ),
      floatingActionButton: user.token != null
          ? FloatingActionButton.extended(
              label: const Text('Finalizar'),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(HomePage.routeName),
                );
              },
            )
          : null,
    );
  }
}
