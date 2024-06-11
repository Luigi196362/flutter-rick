import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';
import 'graphql_queries.dart';
import 'create_user_page.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLogin;

  LoginPage({required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  void _login() async {
    final client = getGraphQLClient();
    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(tokenAuthMutation),
        variables: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      ),
    );

    if (result.hasException) {
      setState(() {
        errorMessage = result.exception.toString();
      });
    } else {
      widget.onLogin(result.data!['tokenAuth']['token']);
      Navigator.pop(context);
    }
  }

  void _navigateToCreateUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateUserPage(
          token: '', // No se necesita un token para crear un usuario
          onUserCreated: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Iniciar sesión',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green[900],
          iconTheme: IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _navigateToCreateUser,
              child: Text('Crear usuario', style: TextStyle(fontSize: 18)),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
