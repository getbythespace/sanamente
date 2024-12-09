// lib/providers/identificacion_provider.dart

import 'package:flutter/material.dart';
import '../repositories/identificacion_repository.dart';
import '../models/usuario.dart';

class IdentificacionProvider with ChangeNotifier {
  final IdentificacionRepository _repository;

  IdentificacionProvider(this._repository);

  Future<void> registrarUsuario(Usuario usuario) async {
    await _repository.saveUsuario(usuario);
    notifyListeners();
  }

  // Si estabas llamando a 'registrarUsuario' desde otros lugares, asegúrate de que este método exista
}
