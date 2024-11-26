import 'package:flutter/material.dart';

class PsicologoScreen extends StatelessWidget {
  const PsicologoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psicólogo'),
      ),
      body: const Center(
        child: Text('Pantalla de Psicólogo'),
      ),
    );
  }
}
