# Laboratorio 2.2 — Widget tipo Gmail (MVVM + Provider)

App Flutter que muestra un widget visual tipo Gmail. Simula acciones basicas
de correo. Arquitectura **MVVM** con **Provider**.

## Fase 1 — Prototipo funcional simulado

### Requisitos cumplidos
- Widget visual similar a Gmail.
- Opcion de busqueda (filtra por asunto o remitente).
- Boton de redactar (formulario simulado).
- Contador de correos no leidos.
- Correos guardados en memoria.
- Buscar correos por asunto o remitente.
- Contar correos no leidos.
- Simular redaccion de un nuevo correo.
- Recepcion de correo simulada (FAB +).
- Interfaz actualizada con Provider (`ChangeNotifier` + `notifyListeners`).

### Arquitectura (separacion MVVM)
```
lib/
├── models/
│   └── correo.dart              # MODEL: datos del correo
├── viewmodels/
│   └── correo_viewmodel.dart    # VIEWMODEL: logica + estado (ChangeNotifier)
├── views/
│   └── home_page.dart           # VIEW: pantalla principal
├── widgets/
│   └── gmail_widget.dart        # WIDGET: componente visual tipo Gmail
└── main.dart                    # MultiProvider + MaterialApp
```

| Capa      | Responsabilidad                                  |
|-----------|--------------------------------------------------|
| Model     | Representa un correo (remitente, asunto, leido). |
| ViewModel | Logica: buscar, contar, marcar leido, redactar.  |
| View      | Pantalla, dialogos de busqueda/redaccion.        |
| Widget    | UI reutilizable que observa el ViewModel.        |

### Ejecutar
```bash
flutter pub get
flutter run
```

### APK generada
```
build/app/outputs/flutter-apk/app-release.apk
```
Generar de nuevo: `flutter build apk --release`

## Fase 2 — Conexion real con Gmail (implementada)

Pantalla **Gmail real** (icono nube en la AppBar): login con Google, lee y
envia correos reales mediante OAuth 2.0 + Gmail API.

Codigo:
```
lib/services/gmail_service.dart       # OAuth + Gmail API (leer/enviar)
lib/viewmodels/gmail_viewmodel.dart   # estado de la Fase 2
lib/views/gmail_real_page.dart        # pantalla de correos reales
```

### Configuracion en Google Cloud (obligatoria para que funcione)
La parte simulada (Fase 1) corre sin nada extra. Para la Fase 2 real:

1. **Proyecto**: https://console.cloud.google.com → crear proyecto.
2. **Habilitar API**: APIs y servicios → Biblioteca → **Gmail API** → Habilitar.
3. **Pantalla de consentimiento OAuth**: tipo **Externo**; agregar scopes
   `gmail.readonly` y `gmail.send`; en **Usuarios de prueba** agregar tu correo
   Gmail (sin esto el login falla con `access_denied`).
4. **Credenciales** → Crear → **ID de cliente OAuth** → tipo **Android**:
   - Nombre del paquete: `com.example.laboratorio_widgets`
   - Huella **SHA-1** (debug): obtenerla con
     ```bash
     keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore \
       -alias androiddebugkey -storepass android -keypass android
     ```
   - Para la APK de *release* repetir con tu keystore de firma.

En Android no se necesita `google-services.json` ni client_id en el codigo:
`google_sign_in` usa el cliente OAuth registrado por **paquete + SHA-1**.
