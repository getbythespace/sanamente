// lib/screens/registro_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/rol.dart';
import '../models/carrera.dart';
import '../utils/extensions.dart';
import '../utils/validators.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  Rol? _selectedRol;
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRol == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un rol.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          rut: _rutController.text.trim(),
          nombres: _nombresController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          rol: _selectedRol!,
          celular: _celularController.text.trim().isNotEmpty ? _celularController.text.trim() : null,
          psicologoAsignado: null,
          campus: _selectedSede == Sede.concepcion ? 'Concepción' : 'Chillán',
          carrera: _selectedCarrera!.nombre,
          edad: int.parse(_edadController.text.trim()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso.')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
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
    _passwordController.dispose();
    _celularController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
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
                      return 'Por favor, ingresa tus nombres.';
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
                      return 'Por favor, ingresa tus apellidos.';
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
                      return 'Por favor, ingresa tu RUT.';
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
                      return 'Por favor, ingresa tu edad.';
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
                      return 'Por favor, ingresa tu correo electrónico.';
                    }
                    if (!validarEmail(value)) {
                      return 'Correo electrónico inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una contraseña.';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres.';
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
                // Selección de Rol
                DropdownButtonFormField<Rol>(
                  value: _selectedRol,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: Rol.values.map((Rol rol) {
                    return DropdownMenuItem<Rol>(
                      value: rol,
                      child: Text(rol.name.capitalize()),
                    );
                  }).toList(),
                  onChanged: (Rol? newRol) {
                    setState(() {
                      _selectedRol = newRol;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona un rol.';
                    }
                    return null;
                  },
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
                // Botón de Registro
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Registrarse'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
