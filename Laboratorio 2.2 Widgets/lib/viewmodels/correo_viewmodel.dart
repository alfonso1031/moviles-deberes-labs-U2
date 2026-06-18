import 'package:flutter/foundation.dart';
import '../models/correo.dart';

class CorreoViewModel extends ChangeNotifier {
  final List<Correo> _correos = [
    Correo(
      id: '1',
      remitente: 'Google',
      asunto: 'Bienvenido a tu nueva cuenta',
      cuerpo: 'Gracias por unirte. Configura tu perfil.',
    ),
    Correo(
      id: '2',
      remitente: 'GitHub',
      asunto: 'Resumen de tu actividad',
      cuerpo: 'Tienes 3 notificaciones pendientes.',
    ),
    Correo(
      id: '3',
      remitente: 'Universidad',
      asunto: 'Recordatorio: entrega Laboratorio 2.2',
      cuerpo: 'No olvides subir el .zip con la APK.',
      leido: true,
    ),
  ];

  String _filtro = '';

  List<Correo> get correos {
    if (_filtro.isEmpty) return List.unmodifiable(_correos);
    final q = _filtro.toLowerCase();
    return _correos
        .where((c) =>
            c.asunto.toLowerCase().contains(q) ||
            c.remitente.toLowerCase().contains(q))
        .toList();
  }

  int get noLeidos => _correos.where((c) => !c.leido).length;
  String get filtro => _filtro;

  void buscar(String texto) {
    _filtro = texto.trim();
    notifyListeners();
  }

  void marcarLeido(String id) {
    final c = _correos.firstWhere((e) => e.id == id);
    if (!c.leido) {
      c.leido = true;
      notifyListeners();
    }
  }

  void marcarTodosLeidos() {
    for (final c in _correos) {
      c.leido = true;
    }
    notifyListeners();
  }

  void recibirNuevoCorreo() {
    final n = _correos.length + 1;
    _correos.insert(
      0,
      Correo(
        id: '$n${DateTime.now().millisecondsSinceEpoch}',
        remitente: 'Remitente $n',
        asunto: 'Nuevo correo simulado #$n',
        cuerpo: 'Este correo llego de forma simulada.',
      ),
    );
    notifyListeners();
  }

  void redactarCorreo({
    required String destinatario,
    required String asunto,
    required String cuerpo,
  }) {
    final n = _correos.length + 1;
    _correos.insert(
      0,
      Correo(
        id: 'env$n${DateTime.now().millisecondsSinceEpoch}',
        remitente: 'Yo -> $destinatario',
        asunto: asunto.isEmpty ? '(sin asunto)' : asunto,
        cuerpo: cuerpo,
        leido: true,
      ),
    );
    notifyListeners();
  }
}
