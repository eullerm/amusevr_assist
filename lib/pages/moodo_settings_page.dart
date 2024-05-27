import 'package:amusevr_assist/api/firebase_api.dart';
import 'package:amusevr_assist/api/moodo_api.dart';
import 'package:amusevr_assist/models/device.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_dialog.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:amusevr_assist/widgets/page_indicator.dart';
import 'package:amusevr_assist/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodoSettingsPage extends StatefulWidget {
  const MoodoSettingsPage({super.key});
  @override
  State<MoodoSettingsPage> createState() => _MoodoSettingsPageState();
}

class _MoodoSettingsPageState extends State<MoodoSettingsPage>
    with TickerProviderStateMixin {
  List<Device> devices = [];
  late User user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showLoginDialog = false;
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  final List<String> itemsMoodo = [
    "Logue com a sua conta AmuseVR;",
    "Vincule a sua conta Moodo com a sua conta AmuseVR;",
    "Selecione o dispositivo Moodo que será usado;",
  ];

  @override
  void initState() {
    user = Provider.of<User>(context, listen: false);
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    if (user.tokenMoodo != null) {
      MoodoApi.fetchDevices(user.tokenMoodo!).then((value) {
        setState(() {
          devices = value;
        });
      });
    } else {
      _showLoginDialog = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void linkMoodoAccount(BuildContext context) {
    try {
      MoodoApi.login(_emailController.text.trim(), _passwordController.text)
          .then((response) {
        if (response.statusCode == 200) {
          user.setTokenMoodo(response.token!);
          MoodoApi.fetchDevices(response.token!).then((value) {
            setState(() {
              devices = value;
            });
          });
          FirebaseApi.settings(user.email!, {'tokenMoodo': response.token!});
          showCustomSnackBar(
              context, 'Conta vinculada com sucesso!', 'success');
          setState(() {
            _showLoginDialog = false;
          });
        } else {
          showCustomSnackBar(context, response.error!, 'error');
        }
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString(), 'error');
    }
  }

  void unlinkMoodoAccount() {
    user.unlinkMoodoAccount();
    devices = [];
    setState(() {
      _showLoginDialog = true;
    });
    FirebaseApi.settings(user.email!, {'deviceKey': null, 'tokenMoodo': null});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<User>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AmuseVR Assist'),
        actions: [
          _currentPageIndex == 1 && user.tokenMoodo != null
              ? IconButton(
                  onPressed: unlinkMoodoAccount,
                  icon: const Icon(Icons.sync_disabled),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: [
              _pageInstructions(),
              _showLoginDialog ? _pageLogin() : _pageSettings(),
            ],
          ),
          PageIndicator(
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
          ),
        ],
      ),
      drawer: CustomDrawer(
        isLogged: user.isAuthenticated,
        actualPage: 'moodoSettingsPage',
        createAccountPageFunction: () {},
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

  Widget _pageInstructions() {
    return ListView.builder(
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
    );
  }

  Widget _pageLogin() {
    return AlertDialog(
      title: const Text(
        'Entre com sua conta Moodo que deseja vincular ao AmuseVR',
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
            Navigator.popAndPushNamed(context, HomePage.routeName);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            linkMoodoAccount(context);
          },
          child: const Text('Vincular'),
        ),
      ],
    );
  }

  Widget _pageSettings() {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return ListTile(
          key: Key(device.id.toString()),
          leading: const Icon(Icons.device_hub),
          trailing: user.deviceKey == device.deviceKey
              ? const Icon(Icons.check_circle, color: Colors.lightGreen)
              : null,
          title: Text(device.name),
          onTap: () {
            _handleItemClick(context, device);
          },
        );
      },
    );
  }
}
