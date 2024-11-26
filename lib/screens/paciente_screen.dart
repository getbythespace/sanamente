import 'package:flutter/material.dart';

class PacienteScreen extends StatelessWidget {
  const PacienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paciente'),
      ),
      body: const Center(
        child: Text('Pantalla de Paciente'),
      ),
    );
  }
}
