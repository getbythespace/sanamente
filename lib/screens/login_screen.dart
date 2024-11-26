import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import 'psicologo_screen.dart';
import 'paciente_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      AuthService authService = Provider.of<AuthService>(context, listen: false);
      Usuario? usuario = await authService.signInWithEmailAndPassword(
          email: _email, password: _password);

      // Verificar si el widget sigue montado
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (usuario != null) {
        // Navegar según el rol
        if (usuario.rol == 'psicologo') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const PsicologoScreen()));
        } else if (usuario.rol == 'paciente') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const PacienteScreen()));
        } else if (usuario.rol == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const AdminScreen()));
        } else {
          setState(() {
            _errorMessage = 'Rol de usuario desconocido.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Credenciales inválidas o usuario no encontrado.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese un email' : null,
                          onSaved: (value) => _email = value!.trim(),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Contraseña'),
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Ingrese una contraseña' : null,
                          onSaved: (value) => _password = value!.trim(),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Ingresar'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/registro');
                          },
                          child: const Text('¿No tienes una cuenta? Regístrate'),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
