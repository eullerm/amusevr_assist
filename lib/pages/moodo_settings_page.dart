import 'package:amusevr_assist/api/moodo_api.dart';
import 'package:amusevr_assist/models/device.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_dialog.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
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

  @override
  void initState() {
    user = Provider.of<User>(context, listen: false);
    MoodoApi.fetchDevices(user.token!).then((value) {
      setState(() {
        devices = value;
      });
    });

    super.initState();
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
        isLogged: user.token != null,
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
      floatingActionButton: user.token != null && user.deviceKey != null
          ? FloatingActionButton.extended(
              label: const Text('Próximo'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EspSettingsPage()),
                );
              },
            )
          : null,
    );
  }

  void _handleItemClick(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: user.deviceKey == device.deviceKey
              ? 'Deseja vincular o dispositivo ${device.name}?'
              : 'Deseja desvincular o dispositivo ${device.name}?',
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
    showCustomSnackBar(context, 'Você selecionou o dispositivo $name', 'info');
    user.setDeviceKey(deviceKey);
  }

  void _handleItemUnselected(BuildContext context, String name) {
    showCustomSnackBar(context, 'Você desvinculou o dispositivo $name', 'info');
    user.removeDeviceKey();
  }
}
