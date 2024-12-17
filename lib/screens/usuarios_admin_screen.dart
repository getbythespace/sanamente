import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/admin_service.dart';
import '../models/usuario.dart';
import '../models/rol.dart';
import '../models/sede.dart';
import '../models/carrera.dart';
import '../utils/validators.dart';
import '../utils/extensions.dart';

class UsuariosAdminScreen extends StatefulWidget {
  const UsuariosAdminScreen({super.key});

  @override
  State<UsuariosAdminScreen> createState() => _UsuariosAdminScreenState();
}

class _UsuariosAdminScreenState extends State<UsuariosAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  Sede? _selectedSede;
  Carrera? _selectedCarrera;
  Rol? _selectedRol;

  bool _isLoading = false;

  List<Carrera> carreras = [
Carrera(nombre: 'Arquitectura', sede: Sede.concepcion),
Carrera(nombre: 'Diseño Industrial', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería en Construcción', sede: Sede.concepcion),
Carrera(nombre: 'Programa de Bachillerato en Ciencias (Concepción)', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Estadística', sede: Sede.concepcion),
Carrera(nombre: 'Contador Público y Auditor (Concepción)', sede: Sede.concepcion),
Carrera(nombre: 'Derecho Carrera Nueva', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil en Informática (Concepción)', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Comercial (Concepción)', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería de Ejecución en Computación e Informática', sede: Sede.concepcion),
Carrera(nombre: 'Trabajo Social (Concepción)', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil Eléctrica', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil en Automatización', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil Industrial', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil Mecánica', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Civil Química', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Eléctrica Carrera Nueva', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Electrónica Carrera Nueva', sede: Sede.concepcion),
Carrera(nombre: 'Ingeniería Mecánica Carrera Nueva', sede: Sede.concepcion),

// Sede Chillán
Carrera(nombre: 'Diseño Gráfico', sede: Sede.chillan),
Carrera(nombre: 'Programa de Bachillerato en Ciencias (Chillán)', sede: Sede.chillan),
Carrera(nombre: 'Ingeniería en Recursos Naturales', sede: Sede.chillan),
Carrera(nombre: 'Química y Farmacia', sede: Sede.chillan),
Carrera(nombre: 'Enfermería', sede: Sede.chillan),
Carrera(nombre: 'Fonoaudiología', sede: Sede.chillan),
Carrera(nombre: 'Ingeniería en Alimentos', sede: Sede.chillan),
Carrera(nombre: 'Medicina', sede: Sede.chillan),
Carrera(nombre: 'Nutrición y Dietética', sede: Sede.chillan),
Carrera(nombre: 'Contador Público y Auditor (Chillán)', sede: Sede.chillan),
Carrera(nombre: 'Ingeniería Civil en Informática (Chillán)', sede: Sede.chillan),
Carrera(nombre: 'Ingeniería Comercial (Chillán)', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Castellano y Comunicación', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Ciencias Naturales mención Biología o Física o Química', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Educación Especial con mención en Dificultades Específicas del Aprendizaje', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Educación Física', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Educación General Básica con mención en Lenguaje y Comunicación o Educación Matemática', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Educación Matemática', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Educación Parvularia Mención Didáctica en Primera Infancia', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Historia y Geografía', sede: Sede.chillan),
Carrera(nombre: 'Pedagogía en Inglés', sede: Sede.chillan),
Carrera(nombre: 'Psicología', sede: Sede.chillan),
Carrera(nombre: 'Trabajo Social (Chillán)', sede: Sede.chillan),

  ];

  List<Carrera> get _carrerasFiltradas {
    if (_selectedSede == null) {
      return [];
    } else {
      return carreras
          .where((carrera) => carrera.sede == _selectedSede)
          .toList();
    }
  }

  void _crearUsuario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Usuario nuevoUsuario = Usuario(
          uid: '', //  se generará automáticamente
          rut: _rutController.text.trim(),
          nombres: _nombresController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          email: _emailController.text.trim(),
          rol: _selectedRol ??
              Rol.paciente, // seleccionado por defecto
          celular: _celularController.text.trim().isNotEmpty
              ? _celularController.text.trim()
              : null,
          psicologoAsignado: null,
          campus: _selectedSede == Sede.concepcion ? 'Concepción' : 'Chillán',
          carrera: _selectedCarrera!.nombre,
          edad: int.parse(_edadController.text.trim()),
        );

        String password = _passwordController.text
            .trim(); // contraseña del formulario

        final adminService = Provider.of<AdminService>(context, listen: false);
        await adminService.crearUsuario(
            nuevoUsuario, password); // Pasar ambos argumentos

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear usuario: $e')),
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
        title: const Text('Administración de Usuarios'),
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
                  decoration:
                      const InputDecoration(labelText: 'Correo Electrónico'),
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
                  decoration:
                      const InputDecoration(labelText: 'Celular (opcional)'),
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
                      _selectedCarrera =
                          null; // Reiniciar carrera al cambiar sede
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
                const SizedBox(height: 16),
                // Selección de Rol (Opcional)
                DropdownButtonFormField<Rol>(
                  value: _selectedRol,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: Rol.values.map((Rol rol) {
                    return DropdownMenuItem<Rol>(
                      value: rol,
                      child: Text(rol.name),
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
                const SizedBox(height: 32),
                // Botón de Creación
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _crearUsuario,
                        child: const Text('Crear Usuario'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
