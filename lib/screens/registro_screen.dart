import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroScreen extends StatelessWidget {
  RegistroScreen({super.key});

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController celularController = TextEditingController();

  void registrarUsuario(BuildContext context) async {
    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();
    final rut = rutController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final celular = celularController.text.trim();

    try {
      final autorizados = await FirebaseFirestore.instance
          .collection('autorizados')
          .where('rut', isEqualTo: rut)
          .get();

      String rol = 'paciente';
      if (autorizados.docs.isNotEmpty) {
        rol = 'psicologo';
      }

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'nombres': nombres,
        'apellidos': apellidos,
        'rut': rut,
        'email': email,
        'rol': rol,
        'celular': celular.isNotEmpty ? celular : null,
        'psicologoAsignado': null,
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso como $rol')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
              ),
              TextField(
                controller: apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              TextField(
                controller: rutController,
                decoration: const InputDecoration(labelText: 'RUT'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              TextField(
                controller: celularController,
                decoration:
                    const InputDecoration(labelText: 'Celular (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => registrarUsuario(context),
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
