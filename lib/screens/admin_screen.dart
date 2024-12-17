import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';
import 'list_usuarios_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _crearUsuario(BuildContext context, Rol rol) {
    Navigator.pushNamed(
      context,
      '/crear_usuario',
      arguments: rol,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final adminService = Provider.of<AdminService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.pushNamed(context, '/perfil');
            },
          ),
        ],
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'crear_paciente',
            onPressed: () {
              _crearUsuario(context, Rol.paciente);
            },
            tooltip: 'Crear Paciente',
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'crear_psicologo',
            onPressed: () {
              _crearUsuario(context, Rol.psicologo);
            },
            tooltip: 'Crear Psicólogo',
            child: const Icon(Icons.psychology),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await authService.signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar Sesión'),
          ),
        ),
      ),
    );
  }
}
