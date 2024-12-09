// lib/repositories/mock_identificacion_repository.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'identificacion_repository.dart';
import '../models/usuario.dart';

class MockIdentificacionRepository implements IdentificacionRepository {
  late List<Usuario> _usuarios;

  MockIdentificacionRepository() {
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    final String response = await rootBundle.loadString('assets/identificacion_mock.json');
    final data = await json.decode(response) as List<dynamic>;
    _usuarios = data.map((json) => Usuario.fromMap(json)).toList();
  }

  @override
  Future<Usuario?> obtenerUsuarioPorRut(String uid) async {
    // Simula una espera
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _usuarios.firstWhere((usuario) => usuario.uid == uid);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUsuario(Usuario usuario) async {
    _usuarios.add(usuario);
    // No es necesario persistir en el mock
  }
}
