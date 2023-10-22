import 'package:amusevr_assist/api/firebase_api.dart';
import 'package:amusevr_assist/utils/functions.dart';
import 'package:amusevr_assist/widgets/password_field.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _wantToBeAuthor = false;

  Future<void> _createAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      showCustomSnackBar(context, 'Por favor, digite o email e a senha!', 'error');
      return;
    }

    if (email.isEmpty) {
      showCustomSnackBar(context, 'O campo email está vazio!', 'error');
      return;
    } else if (!isEmailValid(email)) {
      showCustomSnackBar(context, 'Email inválido. Por favor, insira um email válido.', 'error');
      return;
    }

    if (password.isEmpty) {
      showCustomSnackBar(context, 'O campo senha está vazio!', 'error');
      return;
    }

    await FirebaseApi.createAccount(email, password, _wantToBeAuthor).then((value) {
      if (value.statusCode == 200) {
        Navigator.of(context).pop();
        showCustomSnackBar(context, value.message, 'success');
      } else {
        showCustomSnackBar(context, value.message, 'info');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AmuseVR Assist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Crie uma conta para usar o software AmuseVR'),
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
            Row(
              children: [
                Checkbox(
                  value: _wantToBeAuthor,
                  onChanged: (value) {
                    setState(() {
                      _wantToBeAuthor = value!;
                    });
                  },
                ),
                const Text('Quero ser um autor'),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
