// lib/utils/validators.dart

import 'package:flutter/foundation.dart'; // Import necesario para debugPrint
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/identificacion_repository.dart';
import '../models/usuario.dart';

bool validarRut(String rut) {
  // Eliminar puntos y guión
  rut = rut.replaceAll('.', '').replaceAll('-', '').toUpperCase();
  debugPrint('RUT después de limpieza: $rut');

  // Validar formato: 7 u 8 dígitos seguidos de un dígito o 'K'
  if (!RegExp(r'^\d{7,8}[0-9K]$').hasMatch(rut)) {
    debugPrint('RUT no cumple con el formato esperado.');
    return false;
  }

  try {
    int body = int.parse(rut.substring(0, rut.length - 1));
    String dv = rut.substring(rut.length - 1);
    debugPrint('Body: $body, DV: $dv');

    int sum = 0;
    int multiplier = 2;

    while (body > 0) {
      sum += (body % 10) * multiplier;
      body = body ~/ 10;
      multiplier = multiplier == 7 ? 2 : multiplier + 1;
    }

    int remainder = sum % 11;
    int dvCalc = 11 - remainder;
    debugPrint('Sum: $sum, Remainder: $remainder, DV Calculado: $dvCalc');

    String dvExpected;
    if (dvCalc == 11) {
      dvExpected = '0';
    } else if (dvCalc == 10) {
      dvExpected = 'K';
    } else {
      dvExpected = dvCalc.toString();
    }

    debugPrint('DV Esperado: $dvExpected');
    debugPrint('DV Ingresado: $dv');

    return dv == dvExpected;
  } catch (e) {
    debugPrint('Error en la validación del RUT: $e');
    return false;
  }
}

// Añadir la función validarEmail
bool validarEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  return emailRegex.hasMatch(email);
}
