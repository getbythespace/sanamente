import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../services/auth_service.dart';
import '../services/paciente_service.dart';
import 'pool_pacientes_screen.dart';
import 'mis_pacientes_screen.dart';

class PsicologoScreen extends StatefulWidget {
  const PsicologoScreen({super.key});

  @override
  _PsicologoScreenState createState() => _PsicologoScreenState();
}

class _PsicologoScreenState extends State<PsicologoScreen>
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Psicólogo'),
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Cerrar Sesión'),
          ),
        ),
      ),
    );
  }
}
