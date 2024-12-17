enum Sede {
  concepcion,
  chillan,
}

extension SedeExtension on Sede {
  String get name {
    switch (this) {
      case Sede.concepcion:
        return 'Concepción';
      case Sede.chillan:
        return 'Chillán';
      default:
        return '';
    }
  }
}
