import 'package:amusevr_assist/api/moodo_api.dart';
import 'package:amusevr_assist/models/user.dart';
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
            ),
            const SizedBox(height: 20.0),
            PasswordField(
              passwordController: _passwordController,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                try {
                  MoodoApi.login(_emailController.text, _passwordController.text).then((response) {
                    if (response.statusCode == 200) {
                      user.setToken(response.token!);
                      user.setEmail(_emailController.text);
                      user.setPassword(_passwordController.text);
                      Navigator.pop(context);
                    } else {
                      showCustomSnackBar(context, response.error!, 'error');
                    }
                  });
                } catch (e) {
                  showCustomSnackBar(context, e.toString(), 'error');
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
