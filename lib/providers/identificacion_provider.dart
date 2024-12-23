import 'package:flutter/material.dart';
import '../repositories/identificacion_repository.dart';
import '../models/usuario.dart';

class IdentificacionProvider with ChangeNotifier {
  final IdentificacionRepository _repository;

  IdentificacionProvider(this._repository);

  // Método para registrar usuario
  Future<String?> registerUsuario(Usuario usuario) async {
    try {
      // Verificar unicidad del RUT
      final isUnique = await _repository.isRutUnique(usuario.rut);
      if (!isUnique) {
        return 'El RUT ya está registrado.';
      }

      // Guardar usuario en Firestore
      await _repository.saveUsuario(usuario);
      notifyListeners();
      return null; 
    } catch (e) {
      return e.toString();
    }
  }

  // Método para obtener usuario por RUT
  Future<Usuario?> getUsuarioByRut(String rut) async {
    return await _repository.obtenerUsuarioPorRut(rut);
  }

  // Método para obtener usuario por UID
  Future<Usuario?> getUsuarioByUid(String uid) async {
    return await _repository.obtenerUsuarioPorUid(uid);
  }
}
