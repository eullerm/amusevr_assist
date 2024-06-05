import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/create_account.dart';
import 'package:amusevr_assist/pages/edit_account.dart';
import 'package:amusevr_assist/pages/login_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: user.isAuthenticated,
                child: userInfo(),
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
            ],
          ),
        ),
      ),
      drawer: CustomDrawer(
        isLogged: user.isAuthenticated,
        actualPage: 'homePage',
        homeFunction: () {
          Navigator.pop(context);
        },
        createAccountPageFunction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAccountPage(),
            ),
          );
        },
        espPageFunction: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EspSettingsPage(),
            ),
          );
        },
        logoutFunction: () {
          logout(context);
        },
        moodoPageFunction: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MoodoSettingsPage(),
            ),
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: !user.isAuthenticated,
        child: FloatingActionButton.extended(
          label: const Text('Logar'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 16,
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.name ?? 'Nome não informado',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              elevation: 2,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.black45, width: 1),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditAccountPage(),
                ),
              );
            },
            child: const Text(
              'Editar perfil',
            ),
          ),
        ),
      ],
    );
  }
}
