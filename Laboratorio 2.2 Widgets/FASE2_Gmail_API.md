# Fase 2 — Conexion real con Gmail (investigacion)

Documenta el proceso para conectar la app Flutter con Gmail real mediante la
**API oficial de Google (Gmail API)** y OAuth 2.0.

## 1. Crear proyecto en Google Cloud
1. Entrar a https://console.cloud.google.com
2. Menu superior → **Selector de proyecto** → **Proyecto nuevo**.
3. Nombre: `Laboratorio-Gmail-Flutter` → **Crear**.

## 2. Activar Gmail API
1. **APIs y servicios** → **Biblioteca**.
2. Buscar **Gmail API** → **Habilitar**.

## 3. Configurar pantalla de consentimiento OAuth
1. **APIs y servicios** → **Pantalla de consentimiento de OAuth**.
2. Tipo de usuario: **Externo** → **Crear**.
3. Datos de la app: nombre, correo de soporte, logo (opcional).
4. **Scopes (permisos)** — agregar los necesarios:
   - `https://www.googleapis.com/auth/gmail.readonly` (leer mensajes)
   - `https://www.googleapis.com/auth/gmail.send` (enviar correos)
   - `https://www.googleapis.com/auth/gmail.modify` (marcar leido, etc.)
5. **Usuarios de prueba**: agregar el correo Gmail con el que se probara
   (obligatorio mientras la app este en modo *Testing*).

## 4. Crear credenciales OAuth
1. **APIs y servicios** → **Credenciales** → **Crear credenciales** →
   **ID de cliente de OAuth**.
2. Tipo de aplicacion: **Android**.
3. **Nombre del paquete**: `com.example.laboratorio_widgets`
   (ver `android/app/build.gradle` → `applicationId`).
4. **Huella SHA-1**: obtenerla con:
   ```bash
   keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore ^
     -alias androiddebugkey -storepass android -keypass android
   ```
   (en Windows; para release usar el keystore de firma propio).
5. Crear → se genera el **Client ID**.

## 5. Dependencias en Flutter
`pubspec.yaml`:
```yaml
dependencies:
  google_sign_in: ^6.2.1     # login con Google + tokens OAuth
  googleapis: ^13.2.0        # cliente tipado de Gmail API
  googleapis_auth: ^1.6.0    # cliente HTTP autenticado
  extension_google_sign_in_as_googleapis_auth: ^2.0.12
```

## 6. Inicio de sesion con Google y permisos
```dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

final googleSignIn = GoogleSignIn(scopes: [
  GmailApi.gmailReadonlyScope,
  GmailApi.gmailSendScope,
]);

Future<GmailApi?> conectar() async {
  final cuenta = await googleSignIn.signIn();   // muestra dialogo de permisos
  if (cuenta == null) return null;              // usuario cancelo
  final client = await googleSignIn.authenticatedClient();
  return GmailApi(client!);
}
```

## 7. Leer mensajes reales
```dart
Future<void> leerCorreos(GmailApi api) async {
  final lista = await api.users.messages.list('me', maxResults: 10);
  for (final m in lista.messages ?? []) {
    final full = await api.users.messages.get('me', m.id!);
    final asunto = full.payload?.headers
        ?.firstWhere((h) => h.name == 'Subject',
            orElse: () => MessagePartHeader())
        .value;
    print(asunto);
  }
}
```

## 8. Enviar correos
El cuerpo debe ir como **MIME en Base64 URL-safe**:
```dart
import 'dart:convert';

Future<void> enviar(GmailApi api, String para, String asunto,
    String cuerpo) async {
  final mensaje = 'To: $para\r\n'
      'Subject: $asunto\r\n'
      'Content-Type: text/plain; charset=utf-8\r\n\r\n'
      '$cuerpo';
  final raw = base64Url.encode(utf8.encode(mensaje));
  await api.users.messages.send(Message()..raw = raw, 'me');
}
```

## 9. Integracion con el MVVM existente
- Crear `GmailService` (capa de datos) que envuelva `GmailApi`.
- Inyectarlo en `CorreoViewModel`: reemplazar la lista en memoria por las
  llamadas reales (`leerCorreos`, `enviar`).
- La **View** y el **Widget** no cambian: siguen observando el ViewModel via
  Provider. Solo cambia el origen de los datos (memoria → Gmail real).

## 10. Publicacion
- Mientras la app este en *Testing*, solo los usuarios de prueba pueden entrar.
- Para uso publico: enviar la app a **verificacion de Google** (revisan los
  scopes sensibles de Gmail).

## Resumen
| Paso | Resultado |
|------|-----------|
| Google Cloud + Gmail API | Proyecto y API habilitada |
| Pantalla OAuth + scopes  | Permisos definidos |
| Credenciales Android     | Client ID + SHA-1 |
| google_sign_in           | Login y token OAuth |
| googleapis (Gmail)       | Leer y enviar correos reales |
