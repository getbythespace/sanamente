import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../models/usuario.dart';
import '../services/admin_service.dart';
import '../utils/validators.dart';
import '../utils/extensions.dart'; 
import '../models/sede.dart';
import '../models/carrera.dart';

class CrearUsuarioScreen extends StatefulWidget {
  final Rol rol;

  const CrearUsuarioScreen({required this.rol, super.key});

  @override
  _CrearUsuarioScreenState createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _rutController;
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _celularController;
  late TextEditingController _campusController;
  late TextEditingController _carreraController;
  late TextEditingController _edadController;


  Sede? _selectedSede;


  List<Carrera> _carrerasFiltradas = [];

  
  final List<Carrera> _carreras = [
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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _rutController = TextEditingController();
    _nombresController = TextEditingController();
    _apellidosController = TextEditingController();
    _celularController = TextEditingController();
    _campusController = TextEditingController();
    _carreraController = TextEditingController();
    _edadController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rutController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _celularController.dispose();
    _campusController.dispose();
    _carreraController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  void _crearUsuario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final adminService = Provider.of<AdminService>(context, listen: false);
      try {
        final usuario = Usuario(
          uid: '', // UID será generado por Firebase
          rut: _rutController.text.trim(),
          nombres: _nombresController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          email: _emailController.text.trim(),
          rol: widget.rol,
          celular: _celularController.text.trim().isNotEmpty
              ? _celularController.text.trim()
              : null,
          psicologoAsignado: widget.rol == Rol.paciente
              ? null 
              : null,
          campus: _selectedSede != null ? _selectedSede!.name.capitalize() : '',
          carrera: widget.rol == Rol.paciente
              ? _carreraController.text.trim()
              : '', // Psicólogo no necesita 'carrera'
          edad: int.parse(_edadController.text.trim()),
        );

        await adminService.crearUsuario(
          usuario,
          _passwordController.text.trim(),
        );

        if (!mounted) return; 

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.rol.name.capitalize()} creado exitosamente.')),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return; 
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

  
  void _filtrarCarreras(Sede? sede) {
    setState(() {
      _selectedSede = sede;
      if (sede != null) {
        _carrerasFiltradas = _carreras
            .where((carrera) => carrera.sede == sede)
            .toList();
        _carreraController.text = ''; 
      } else {
        _carrerasFiltradas = [];
        _carreraController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPaciente = widget.rol == Rol.paciente;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear ${widget.rol.name.capitalize()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // RUT
                TextFormField(
                  controller: _rutController,
                  decoration: const InputDecoration(labelText: 'RUT'),
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
                // Nombres
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
                // Apellidos
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
                // Email
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
                // Contraseña
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
                // Celular
                TextFormField(
                  controller: _celularController,
                  decoration: const InputDecoration(labelText: 'Celular (opcional)'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                // Campus - Dropdown
                DropdownButtonFormField<Sede>(
                  decoration: const InputDecoration(labelText: 'Campus'),
                  value: _selectedSede,
                  items: Sede.values.map((Sede sede) {
                    return DropdownMenuItem<Sede>(
                      value: sede,
                      child: Text(sede.name.capitalize()),
                    );
                  }).toList(),
                  onChanged: (Sede? newValue) {
                    _filtrarCarreras(newValue);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona un campus.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Carrera Dropdown solo para Pacientes
                if (isPaciente)
                  DropdownButtonFormField<Carrera>(
                    decoration: const InputDecoration(labelText: 'Carrera'),
                    value: _carreraController.text.isNotEmpty
                        ? _carrerasFiltradas.firstWhere(
                            (carrera) => carrera.nombre == _carreraController.text,
                            orElse: () => _carrerasFiltradas.first,
                          )
                        : null,
                    items: _carrerasFiltradas.map((Carrera carrera) {
                      return DropdownMenuItem<Carrera>(
                        value: carrera,
                        child: Text(carrera.nombre),
                      );
                    }).toList(),
                    onChanged: (Carrera? newValue) {
                      if (newValue != null) {
                        _carreraController.text = newValue.nombre;
                      } else {
                        _carreraController.text = '';
                      }
                    },
                    validator: (value) {
                      if (isPaciente && value == null) {
                        return 'Por favor, selecciona una carrera.';
                      }
                      return null;
                    },
                  ),
                if (isPaciente) const SizedBox(height: 16),
                // Edad
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
                const SizedBox(height: 32),
                // Botón de Crear Usuario
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
