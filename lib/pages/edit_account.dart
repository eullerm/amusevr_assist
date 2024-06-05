import 'package:amusevr_assist/api/firebase_api.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/esp_settings_page.dart';
import 'package:amusevr_assist/pages/home_page.dart';
import 'package:amusevr_assist/pages/moodo_settings_page.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/custom_drawer.dart';
import 'package:amusevr_assist/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User user;

  Future<void> _editAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    await FirebaseApi.editAccount(user.email!, password, name).then((value) {
      if (value.statusCode == 200) {
        user.setName(name);
        Navigator.of(context).pop();
        showCustomSnackBar(context, value.message, 'success');
      } else {
        showCustomSnackBar(context, value.message, 'info');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadUser();
    });
  }

  _loadUser() {
    user = Provider.of<User>(context, listen: false);
    _nameController.text = user.name!;
    _passwordController.text = user.password!;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<User>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("AmuseVR Assist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                PasswordField(
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _editAccount,
                  child: const Text('Salvar alteração'),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(
        isLogged: true,
        actualPage: 'EditAccountPage',
        homeFunction: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        createAccountPageFunction: () {},
        espPageFunction: () {
          Navigator.pushReplacement(
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MoodoSettingsPage(),
            ),
          );
        },
      ),
    );
  }
}
