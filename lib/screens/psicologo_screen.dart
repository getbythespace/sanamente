// lib/screens/psicologo_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import 'pool_pacientes_screen.dart';
import 'mis_pacientes_screen.dart';

class PsicologoScreen extends StatefulWidget {
  const PsicologoScreen({Key? key}) : super(key: key);

  @override
  _PsicologoScreenState createState() => _PsicologoScreenState();
}

class _PsicologoScreenState extends State<PsicologoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _crearUsuario(BuildContext context, Rol rol) {
    Navigator.pushNamed(context, '/crear_usuario');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psicólogo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pool de Pacientes'),
            Tab(text: 'Mis Pacientes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PoolPacientesScreen(),
          MisPacientesScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Crear usuario dependiendo de la pestaña seleccionada
          _crearUsuario(context, Rol.psicologo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
