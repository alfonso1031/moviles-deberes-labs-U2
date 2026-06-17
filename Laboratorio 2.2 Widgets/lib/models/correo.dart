/// Model (capa MODEL del patron MVVM).
/// Representa un correo electronico simulado guardado en memoria.
class Correo {
  final String id;
  final String remitente;
  final String asunto;
  final String cuerpo;
  bool leido;
  final DateTime fecha;

  Correo({
    required this.id,
    required this.remitente,
    required this.asunto,
    required this.cuerpo,
    this.leido = false,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();

  /// Inicial del remitente para el avatar circular.
  String get inicial =>
      remitente.isNotEmpty ? remitente[0].toUpperCase() : '?';
}
