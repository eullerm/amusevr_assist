import 'package:amusevr_assist/api/firebase_api.dart';
import 'package:amusevr_assist/models/user.dart';
import 'package:amusevr_assist/pages/create_account.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late User user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<User>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              PasswordField(
                passwordController: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                  );
                },
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if (!_formKey.currentState!.validate()) return;

    try {
      FirebaseApi.login(_emailController.text, _passwordController.text).then((response) {
        if (response.statusCode == 200) {
          user.setIsAuthenticated(true);
          user.setDeviceKey(response.body!['deviceKey']);
          user.setTokenMoodo(response.body!['tokenMoodo']);
          user.setEspIpAddress(response.body!['espIpAddress']);
          Navigator.pop(context);
        } else {
          showCustomSnackBar(context, response.message, 'error');
        }
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString(), 'error');
    }
  }
}
