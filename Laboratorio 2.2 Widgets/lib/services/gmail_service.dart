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
