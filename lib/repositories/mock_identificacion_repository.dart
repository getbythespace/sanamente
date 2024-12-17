import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'identificacion_repository.dart';
import '../models/usuario.dart';
import '../models/rol.dart';

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
  Future<Usuario?> obtenerUsuarioPorRut(String rut) async {
   
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _usuarios.firstWhere((usuario) => usuario.rut == rut);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Usuario?> obtenerUsuarioPorUid(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _usuarios.firstWhere((usuario) => usuario.uid == uid);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUsuario(Usuario usuario) async {
    final index = _usuarios.indexWhere((u) => u.uid == usuario.uid);
    if (index >= 0) {
      _usuarios[index] = usuario; 
    } else {
      _usuarios.add(usuario); 
    }
  }

  @override
  Future<bool> isRutUnique(String rut) async {
    return !_usuarios.any((usuario) => usuario.rut == rut);
  }

  @override
  Future<List<Usuario>> obtenerUsuariosPorRol(Rol rol) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _usuarios.where((usuario) => usuario.rol == rol).toList();
  }

  @override
  Future<List<Usuario>> obtenerTodosLosUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _usuarios;
  }

  @override
  Future<void> eliminarUsuario(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _usuarios.removeWhere((usuario) => usuario.uid == uid);
  }
}
