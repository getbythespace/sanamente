// lib/screens/editar_usuario_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../models/carrera.dart';
import '../models/usuario.dart';
import '../services/admin_service.dart';
import '../utils/extensions.dart';
import '../utils/validators.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuarioScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<EditarUsuarioScreen> createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _rutController;
  late TextEditingController _emailController;
  late TextEditingController _celularController;
  late TextEditingController _edadController;

  Sede? _selectedSede;
  Carrera? _selectedCarrera;

  bool _isLoading = false;

  List<Carrera> get _carrerasFiltradas {
    if (_selectedSede == null) {
      return [];
    } else {
      return carreras.where((carrera) => carrera.sede == _selectedSede).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController(text: widget.usuario.nombres);
    _apellidosController = TextEditingController(text: widget.usuario.apellidos);
    _rutController = TextEditingController(text: widget.usuario.rut);
    _emailController = TextEditingController(text: widget.usuario.email);
    _celularController = TextEditingController(text: widget.usuario.celular ?? '');
    _edadController = TextEditingController(text: widget.usuario.edad.toString());
    _selectedSede = widget.usuario.campus == 'Concepción' ? Sede.concepcion : Sede.chillan;
    _selectedCarrera = carreras.firstWhere(
      (c) => c.nombre == widget.usuario.carrera && c.sede == _selectedSede,
      orElse: () => carreras.first,
    );
  }

  void _editarUsuario() async {
    if (_formKey.currentState!.validate()) {
      String nombres = _nombresController.text.trim();
      String apellidos = _apellidosController.text.trim();
      String rut = _rutController.text.trim();
      String email = _emailController.text.trim();
      String celular = _celularController.text.trim();
      String edadTexto = _edadController.text.trim();

      int? edad = int.tryParse(edadTexto);
      if (edad == null || edad < 18 || edad > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edad inválida. Debe ser entre 18 y 100 años.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final adminService = Provider.of<AdminService>(context, listen: false);
        Usuario updatedUsuario = Usuario(
          uid: widget.usuario.uid,
          rut: rut,
          nombres: nombres,
          apellidos: apellidos,
          email: email,
          rol: widget.usuario.rol,
          celular: celular.isNotEmpty ? celular : null,
          psicologoAsignado: widget.usuario.psicologoAsignado,
          campus: _selectedSede == Sede.concepcion ? 'Concepción' : 'Chillán',
          carrera: _selectedCarrera!.nombre,
          edad: edad,
        );

        await adminService.editarUsuario(updatedUsuario);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario ${updatedUsuario.nombres} actualizado exitosamente.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar usuario: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _rutController.dispose();
    _emailController.dispose();
    _celularController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.usuario.rol.name.capitalize()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de Nombres
                TextFormField(
                  controller: _nombresController,
                  decoration: const InputDecoration(labelText: 'Nombres'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa los nombres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de Apellidos
                TextFormField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa los apellidos.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de RUT
                TextFormField(
                  controller: _rutController,
                  decoration: const InputDecoration(labelText: 'RUT'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el RUT.';
                    }
                    if (!validarRut(value)) {
                      return 'RUT inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de Edad
                TextFormField(
                  controller: _edadController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa la edad.';
                    }
                    int? edad = int.tryParse(value);
                    if (edad == null || edad < 18 || edad > 100) {
                      return 'Edad inválida. Debe ser entre 18 y 100 años.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de Correo Electrónico
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el correo electrónico.';
                    }
                    if (!validarEmail(value)) {
                      return 'Correo electrónico inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de Celular (Opcional)
                TextFormField(
                  controller: _celularController,
                  decoration: const InputDecoration(labelText: 'Celular (opcional)'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                // Selección de Sede
                DropdownButtonFormField<Sede>(
                  value: _selectedSede,
                  decoration: const InputDecoration(labelText: 'Sede'),
                  items: Sede.values.map((Sede sede) {
                    return DropdownMenuItem<Sede>(
                      value: sede,
                      child: Text(sede.name),
                    );
                  }).toList(),
                  onChanged: (Sede? newSede) {
                    setState(() {
                      _selectedSede = newSede;
                      _selectedCarrera = null;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona una sede.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Selección de Carrera
                DropdownButtonFormField<Carrera>(
                  value: _selectedCarrera,
                  decoration: const InputDecoration(labelText: 'Carrera'),
                  items: _carrerasFiltradas.map((Carrera carrera) {
                    return DropdownMenuItem<Carrera>(
                      value: carrera,
                      child: Text(carrera.nombre),
                    );
                  }).toList(),
                  onChanged: (Carrera? newCarrera) {
                    setState(() {
                      _selectedCarrera = newCarrera;
                    });
                  },
                  validator: (value) {
                    if (_selectedSede != null && value == null) {
                      return 'Por favor, selecciona una carrera.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Botón de Guardar Cambios
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _editarUsuario,
                        child: const Text('Guardar Cambios'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
