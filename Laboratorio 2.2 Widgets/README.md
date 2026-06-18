# Conexion a Gmail (Flutter + MVVM)

App Flutter que se conecta a **Gmail real** con OAuth 2.0 + Gmail API.
Al abrir pide iniciar sesion con Google y muestra tus correos: leer, buscar,
contar no leidos y redactar/enviar.

Arquitectura **MVVM** con **Provider**.

---

## Requisitos previos
- **Flutter SDK** 3.11+ — https://docs.flutter.dev/get-started/install
- **Android Studio** / Android SDK + emulador con Google Play o celular real.
- Verificar: `flutter doctor`

## Instalacion y ejecucion
```bash
git clone https://github.com/alfonso1031/moviles-deberes-labs-U2.git
cd "moviles-deberes-labs-U2/Conexion a Gmail"   # o el nombre de la carpeta
flutter pub get
flutter run
```
Al iniciar, la app abre el dialogo de Google → elige tu cuenta → acepta
permisos → ves tus correos.

APK compilada lista en la raiz de la carpeta: `app-release.apk`
```bash
flutter install            # o: adb install app-release.apk
flutter build apk --release   # generar de nuevo
```

---

## Funcionalidad
| Accion | Que hace |
|--------|----------|
| Inicio automatico | Pide login con Google al abrir. |
| Lista de correos | Muestra los mas recientes de tu Gmail real. |
| Buscar | Filtra por asunto o remitente. |
| Badge "N no leidos" | Cuenta los correos con etiqueta UNREAD. |
| Redactar (FAB) | Envia un correo real desde tu cuenta. |
| Refrescar / Salir | Recarga la bandeja / cierra sesion. |

## Arquitectura (MVVM)
```
lib/
├── models/correo.dart                 # MODEL
├── services/gmail_service.dart        # OAuth + Gmail API (leer/enviar)
├── viewmodels/gmail_viewmodel.dart    # VIEWMODEL (estado + logica)
├── views/gmail_page.dart              # VIEW (pantalla)
└── main.dart
```

---

## Configuracion en Google Cloud (OBLIGATORIA)

> **Importante:** en Android **no se usa ninguna API key ni client_id dentro
> del codigo**. `google_sign_in` identifica la app por **nombre de paquete +
> huella SHA-1** registrados en el cliente OAuth de Google Cloud. Por eso no
> hay credenciales en los archivos `.dart`.

Pasos (una sola vez):

1. **Proyecto** — https://console.cloud.google.com → crear proyecto.
2. **Habilitar Gmail API** — APIs y servicios → Biblioteca → *Gmail API* →
   Habilitar.
3. **Pantalla de consentimiento OAuth** (Google Auth Platform):
   - Tipo: **Externo**.
   - Permisos (scopes): `gmail.readonly` y `gmail.send`.
   - **Publico → Usuarios de prueba**: agrega tu correo Gmail. Sin esto el
     login da `access_denied` (la app esta en modo *Testing*).
4. **Clientes → Crear credenciales → ID de cliente OAuth**, tipo **Android**:
   - **Nombre del paquete**: `com.example.laboratorio_widgets`
   - **Huella SHA-1** del keystore con el que compilas. Para *debug*:
     ```bash
     keytool -list -v \
       -keystore %USERPROFILE%\.android\debug.keystore \
       -alias androiddebugkey -storepass android -keypass android
     ```
     (copia la linea `SHA1:`). Para una APK de *release*, repite con tu
     keystore de firma y registra tambien ese SHA-1.

### ¿Hace falta configurar el archivo `.properties`?
**No para que la app funcione.** El archivo `android/oauth.properties` es solo
una **referencia/documentacion** de los valores OAuth del proyecto; ni el
codigo ni Gradle lo leen. La autenticacion depende del paso 4 (paquete +
SHA-1 en Google Cloud), no de este archivo.

Esta **ignorado por git** (no se sube). Si lo quieres tener localmente,
crea `android/oauth.properties` con este formato:
```properties
# Referencia OAuth (no se consume en el codigo; Android usa paquete + SHA-1)
oauth.androidClientId=TU_CLIENT_ID.apps.googleusercontent.com
oauth.packageName=com.example.laboratorio_widgets
oauth.sha1=TU:HUELLA:SHA1
```

### Si otra persona clona el repo
Su keystore de debug tiene un **SHA-1 distinto**. Para que el login le
funcione debe **registrar su propio SHA-1** (mismo paquete) en el cliente
OAuth Android del proyecto de Google Cloud, y estar agregado como usuario de
prueba.
