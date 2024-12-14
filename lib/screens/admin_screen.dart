// lib/screens/admin_screen.dart

import 'package:flutter/material.dart';

import '../models/rol.dart';

import 'list_usuarios_screen.dart';


class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Administrador'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pacientes'),
            Tab(text: 'Psicólogos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ListUsuariosScreen(rol: Rol.paciente),
          ListUsuariosScreen(rol: Rol.psicologo),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Crear usuario dependiendo de la pestaña seleccionada
          Rol rol = _tabController.index == 0 ? Rol.paciente : Rol.psicologo;
          Navigator.pushNamed(context, '/crear_usuario', arguments: rol);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
