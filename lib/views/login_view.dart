import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'dashboard_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _controller = LoginController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';

  Future<void> _login() async {
    final success = await _controller.login(
      _usernameController.text,
      _passwordController.text,
    );
    setState(() {
      if (success) {
        _error = '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardView()),
        );
      } else {
        _error = 'Usuário ou senha inválidos';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Entrar'),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(_error, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
