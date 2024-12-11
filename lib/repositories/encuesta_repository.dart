// lib/repositories/encuesta_repository.dart

import '../models/encuesta.dart';

abstract class EncuestaRepository {
  Future<void> saveEncuesta(Encuesta encuesta);
  Future<List<Encuesta>> getEncuestasByUsuario(String usuarioId);
  Future<void> updateEncuesta(Encuesta encuesta);
  Future<void> deleteEncuesta(String encuestaId);
}
