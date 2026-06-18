import 'package:flutter/foundation.dart';
import '../models/correo.dart';
import '../services/gmail_service.dart';

/// ViewModel de la Fase 2 (Gmail real).
/// Misma capa MVVM, pero los datos vienen de la Gmail API.
class GmailViewModel extends ChangeNotifier {
  final GmailService _service = GmailService();

  List<Correo> _correos = [];
  bool _cargando = false;
  String? _error;
  String _filtro = '';

  bool get conectado => _service.conectado;
  String? get correoUsuario => _service.correoUsuario;
  bool get cargando => _cargando;
  String? get error => _error;
  String get filtro => _filtro;

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

  void buscar(String texto) {
    _filtro = texto.trim();
    notifyListeners();
  }

  Future<void> conectar() async {
    _setCargando(true);
    try {
      final ok = await _service.iniciarSesion();
      if (ok) {
        await _recargar();
      } else {
        _error = 'Inicio de sesion cancelado';
      }
    } catch (e) {
      _error = 'Error al conectar: $e';
    } finally {
      _setCargando(false);
    }
  }

  Future<void> desconectar() async {
    await _service.cerrarSesion();
    _correos = [];
    notifyListeners();
  }

  Future<void> recargar() async {
    _setCargando(true);
    try {
      await _recargar();
    } catch (e) {
      _error = 'Error al leer correos: $e';
    } finally {
      _setCargando(false);
    }
  }

  Future<void> enviar({
    required String destinatario,
    required String asunto,
    required String cuerpo,
  }) async {
    _setCargando(true);
    try {
      await _service.enviarCorreo(
        destinatario: destinatario,
        asunto: asunto,
        cuerpo: cuerpo,
      );
      await _recargar();
    } catch (e) {
      _error = 'Error al enviar: $e';
    } finally {
      _setCargando(false);
    }
  }

  /// Devuelve el cuerpo completo de un correo real.
  Future<String> obtenerCuerpo(String messageId) =>
      _service.obtenerCuerpo(messageId);

  Future<void> _recargar() async {
    _correos = await _service.leerCorreos();
    _error = null;
  }

  void _setCargando(bool v) {
    _cargando = v;
    notifyListeners();
  }
}
