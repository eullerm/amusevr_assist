import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/create_account.dart';
import 'package:amusevr_assist/pages/login_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;

  final List<String> itemsMoodo = [
    "Logue com a sua conta AmuseVR;",
    "Vincule a sua conta Moodo com a sua conta AmuseVR"
        "Selecione o dispositivo Moodo que será usado;",
  ];

  final List<String> itemsESP = [
    "Logue com a sua conta AmuseVR;",
    "Conecte-se na rede WiFi do ESP;",
    "Selecione a rede que você deseja que o ESP se conecte;",
    "Pronto, o ESP está configurado!",
  ];

  final List<String> warnings = [
    "O AmuseVR não liga nem desliga o dispositivo Moodo em si, apenas envia os comandos que ligam e desligam as fragrâncias.",
    "Certifique-se de que o dispositivo Moodo está ligado e conectado a uma rede WiFi.",
    "As configurações de WiFi do Moodo devem ser feitas pelo aplicativo oficial.",
    'É necessário possuir uma conta do AmuseVR para usar o software.'
  ];

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<User>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("AmuseVR Assist"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Instruções Moodo:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsMoodo.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(itemsMoodo[index]),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              height: 0,
              thickness: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Instruções ESP:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsESP.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(itemsESP[index]),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              height: 0,
              thickness: 1,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Avisos:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: warnings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Text(('*')),
                  ),
                  title: Text(warnings[index]),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: !user.isAuthenticated,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                        );
                      },
                      child: const Text('Criar conta'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(
        isLogged: user.isAuthenticated,
        actualPage: 'homePage',
        homeFunction: () {
          Navigator.pop(context);
        },
        espPageFunction: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EspSettingsPage()),
          );
        },
        logoutFunction: () {
          logout(context);
        },
        moodoPageFunction: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MoodoSettingsPage()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Começar'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => user.isAuthenticated ? const MoodoSettingsPage() : LoginPage()),
          );
        },
      ),
    );
  }
}
