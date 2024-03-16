import 'package:amusevr_assist/api/firebase_api.dart';
import 'package:amusevr_assist/api/moodo_api.dart';
import 'package:amusevr_assist/models/device.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_dialog.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:amusevr_assist/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodoSettingsPage extends StatefulWidget {
  const MoodoSettingsPage({super.key});
  @override
  State<MoodoSettingsPage> createState() => _MoodoSettingsPageState();
}

class _MoodoSettingsPageState extends State<MoodoSettingsPage> {
  List<Device> devices = [];
  late User user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    user = Provider.of<User>(context, listen: false);
    if (user.tokenMoodo != null) {
      MoodoApi.fetchDevices(user.tokenMoodo!).then((value) {
        setState(() {
          devices = value;
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: modalLogin(),
          ),
        ),
      );
    }
    super.initState();
  }

  void linkMoodoAccount() {
    try {
      MoodoApi.login(_emailController.text, _passwordController.text).then((response) {
        if (response.statusCode == 200) {
          user.setTokenMoodo(response.token!);
          MoodoApi.fetchDevices(user.tokenMoodo!).then((value) {
            setState(() {
              devices = value;
            });
          });
          FirebaseApi.settings(user.email!, {'tokenMoodo': response.token!});
          showCustomSnackBar(context, 'Conta vinculada com sucesso!', 'success');
          Navigator.pop(context);
        } else {
          showCustomSnackBar(context, response.error!, 'error');
        }
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString(), 'error');
    }
  }

  Widget modalLogin() {
    return AlertDialog(
      title: const Text(
        'Entre com sua conta AmuseVR que deseja vincular ao ESP',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          PasswordField(
            passwordController: _passwordController,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              HomePage.routeName,
            );
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            linkMoodoAccount();
          },
          child: const Text('Vincular'),
        ),
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
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            key: Key(device.id.toString()),
            leading: const Icon(Icons.device_hub),
            trailing: user.deviceKey == device.deviceKey
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.lightGreen,
                  )
                : null,
            title: Text(device.name),
            onTap: () {
              _handleItemClick(context, device);
            },
          );
        },
      ),
      drawer: CustomDrawer(
        isLogged: user.isAuthenticated,
        actualPage: 'moodoSettingsPage',
        homeFunction: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        espPageFunction: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EspSettingsPage()),
          );
        },
        logoutFunction: () {
          logout(context);
        },
        moodoPageFunction: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _handleItemClick(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: user.deviceKey == device.deviceKey
              ? 'Deseja desvincular o dispositivo ${device.name}?'
              : 'Deseja vincular o dispositivo ${device.name}?',
          items: {
            "Id": device.id,
            "Device Key": device.deviceKey,
            "Box Status": device.boxStatus,
            "Is Online": device.isOnline ? 'Sim' : 'Não',
            "Está carregando": device.isBatteryCharging ? 'Sim' : 'Não',
            "Bateria": "${device.batteryLevelPercent}%",
          },
          onConfirm: () {
            user.deviceKey != device.deviceKey
                ? _handleItemSelected(context, device.deviceKey, device.name)
                : _handleItemUnselected(context, device.name);
          },
        );
      },
    );
  }

  void _handleItemSelected(BuildContext context, int deviceKey, String name) {
    FirebaseApi.settings(user.email!, {'deviceKey': deviceKey});
    showCustomSnackBar(context, 'Você selecionou o dispositivo $name', 'info');
    user.setDeviceKey(deviceKey);
  }

  void _handleItemUnselected(BuildContext context, String name) {
    FirebaseApi.settings(user.email!, {'deviceKey': null});
    showCustomSnackBar(context, 'Você desvinculou o dispositivo $name', 'info');
    user.removeDeviceKey();
  }
}
