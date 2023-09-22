import 'package:amusevr_assist/api/moodo_api.dart';
import 'package:amusevr_assist/models/device.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodoSettingsPage extends StatefulWidget {
  const MoodoSettingsPage({super.key});
  @override
  State<MoodoSettingsPage> createState() => _MoodoSettingsPageState();
}

class _MoodoSettingsPageState extends State<MoodoSettingsPage> {
  final List<String> colors = [
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Orange',
    'Purple',
  ];

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

    if (user.token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }

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
    );
  }

  void _handleItemClick(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(device.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${device.id}'),
              Text('Box Version: ${device.deviceKey}'),
              // Add more details as needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _handleItemSelected(BuildContext context, int deviceKey, String name) {
    showCustomSnackBar(context, 'Você selecionou o dispositivo $name', 'info');
    user.setDeviceKey(deviceKey);
  }
}
