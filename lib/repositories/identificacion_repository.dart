import '../models/usuario.dart';

abstract class IdentificacionRepository {
  Future<Usuario?> obtenerUsuarioPorRut(String rut); // Buscar por RUT
  Future<Usuario?> obtenerUsuarioPorUid(String uid); // Buscar por UID
  Future<void> saveUsuario(Usuario usuario); 
  Future<bool> isRutUnique(String rut); // Verificar unicidad del RUT
}