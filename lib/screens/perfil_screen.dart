// lib/screens/perfil_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../utils/extensions.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _celularController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    Usuario? usuario = await authService.currentUser;
    if (usuario != null) {
      _emailController = TextEditingController(text: usuario.email);
      _celularController = TextEditingController(text: usuario.celular ?? '');
      setState(() {});
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final usuario = await authService.currentUser;

      if (usuario == null) return;

      // Actualizar email y celular
      String email = _emailController.text.trim();
      String celular = _celularController.text.trim();

      try {
        await authService.updateUserProfile(email: email, celular: celular);

        // Actualizar contraseña si se proporcionó
        if (_passwordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty) {
          await authService.updatePassword(
            currentPassword: _passwordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado exitosamente.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _celularController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Usuario?>(
          future: Provider.of<AuthService>(context, listen: false).currentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final Usuario? usuario = snapshot.data;

            if (usuario == null) {
              return const Center(child: Text('No se encontró el usuario.'));
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mostrar información no editable
                    ListTile(
                      title: const Text('RUT'),
                      subtitle: Text(usuario.rut),
                    ),
                    ListTile(
                      title: const Text('Nombre'),
                      subtitle: Text('${usuario.nombres} ${usuario.apellidos}'),
                    ),
                    ListTile(
                      title: const Text('Rol'),
                      subtitle: Text(usuario.rol.name.capitalize()),
                    ),
                    const SizedBox(height: 20),
                    // Campos editables
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu correo electrónico.';
                        }
                        if (!validarEmail(value)) {
                          return 'Correo electrónico inválido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _celularController,
                      decoration: const InputDecoration(labelText: 'Celular'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    // Cambio de contraseña
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Cambiar Contraseña',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Contraseña Actual'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(labelText: 'Nueva Contraseña'),
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && value.length < 6) {
                          return 'La nueva contraseña debe tener al menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
