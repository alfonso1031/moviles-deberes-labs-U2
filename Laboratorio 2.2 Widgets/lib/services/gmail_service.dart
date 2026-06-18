import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../models/correo.dart';

/// Service (capa de DATOS de la Fase 2).
/// Conexion real con Gmail mediante OAuth 2.0 + Gmail API.
class GmailService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      GmailApi.gmailReadonlyScope, // leer mensajes
      GmailApi.gmailSendScope, // enviar correos
    ],
  );

  GoogleSignInAccount? _cuenta;
  GmailApi? _api;

  String? get correoUsuario => _cuenta?.email;
  bool get conectado => _api != null;

  /// Inicia sesion con Google y solicita permisos.
  Future<bool> iniciarSesion() async {
    _cuenta = await _googleSignIn.signIn();
    if (_cuenta == null) return false; // usuario cancelo
    final client = await _googleSignIn.authenticatedClient();
    if (client == null) return false;
    _api = GmailApi(client);
    return true;
  }

  /// Cierra la sesion.
  Future<void> cerrarSesion() async {
    await _googleSignIn.disconnect();
    _cuenta = null;
    _api = null;
  }

  /// Lee los mensajes reales mas recientes del usuario.
  Future<List<Correo>> leerCorreos({int max = 15}) async {
    final api = _api;
    if (api == null) return [];

    final lista = await api.users.messages.list('me', maxResults: max);
    final mensajes = lista.messages ?? [];
    final result = <Correo>[];

    for (final ref in mensajes) {
      final full = await api.users.messages.get(
        'me',
        ref.id!,
        format: 'metadata',
        metadataHeaders: ['From', 'Subject'],
      );
      final headers = full.payload?.headers ?? [];
      String header(String n) => headers
          .firstWhere((h) => h.name == n,
              orElse: () => MessagePartHeader())
          .value ??
          '';

      final noLeido = full.labelIds?.contains('UNREAD') ?? false;
      result.add(
        Correo(
          id: ref.id!,
          remitente: header('From'),
          asunto: header('Subject').isEmpty ? '(sin asunto)' : header('Subject'),
          cuerpo: full.snippet ?? '',
          leido: !noLeido,
        ),
      );
    }
    return result;
  }

  /// Obtiene el cuerpo completo de un mensaje real.
  /// Extrae texto plano; si no existe, limpia el HTML.
  Future<String> obtenerCuerpo(String messageId) async {
    final api = _api;
    if (api == null) return '';

    final msg = await api.users.messages.get('me', messageId, format: 'full');
    return _extraerTexto(msg.payload) ?? msg.snippet ?? '';
  }

  /// Recorre el arbol MIME buscando text/plain; fallback a text/html sin tags.
  String? _extraerTexto(MessagePart? part) {
    if (part == null) return null;

    final mime = part.mimeType ?? '';

    // Parte simple con datos
    if (part.body?.data != null) {
      final decoded = utf8.decode(
        base64Url.decode(part.body!.data!.replaceAll('-', '+').replaceAll('_', '/')),
        allowMalformed: true,
      );
      if (mime == 'text/plain') return decoded;
      if (mime == 'text/html') return _stripHtml(decoded);
    }

    // Multipart: buscar primero text/plain en los hijos
    final partes = part.parts ?? [];
    for (final p in partes) {
      if ((p.mimeType ?? '').contains('plain')) {
        final r = _extraerTexto(p);
        if (r != null) return r;
      }
    }
    // Fallback: cualquier parte legible
    for (final p in partes) {
      final r = _extraerTexto(p);
      if (r != null) return r;
    }
    return null;
  }

  /// Quita etiquetas HTML dejando solo el texto.
  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<style[^>]*>.*?</style>', dotAll: true), '')
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true), '')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<p[^>]*>'), '\n')
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  /// Envia un correo real desde la cuenta del usuario.
  Future<void> enviarCorreo({
    required String destinatario,
    required String asunto,
    required String cuerpo,
  }) async {
    final api = _api;
    if (api == null) return;

    final mime = 'To: $destinatario\r\n'
        'Subject: $asunto\r\n'
        'Content-Type: text/plain; charset=utf-8\r\n\r\n'
        '$cuerpo';
    final raw = base64Url.encode(utf8.encode(mime));
    await api.users.messages.send(Message()..raw = raw, 'me');
  }
}
