import 'sede.dart';

class Carrera {
  final String nombre;
  final Sede sede;

  Carrera({
    required this.nombre,
    required this.sede,
  });
}


final List<Carrera> carreras = [
  // Sede Concepción
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
