# Laboratorio 2.2 — Widget tipo Gmail (MVVM + Provider)

App Flutter con un widget visual tipo Gmail. Simula acciones basicas de correo.
Arquitectura **MVVM** + **Provider**.

---

## Requisitos previos
- **Flutter SDK** (3.11 o superior) — https://docs.flutter.dev/get-started/install
- **Android Studio** o el **Android SDK** + un emulador o dispositivo fisico.
- Verificar instalacion:
  ```bash
  flutter doctor
  ```

## Instalacion
```bash
# 1. Clonar el repo
git clone https://github.com/alfonso1031/moviles-deberes-labs-U2.git

# 2. Entrar a la carpeta del proyecto
cd "moviles-deberes-labs-U2/Laboratorio 2.2 Widgets"

# 3. Descargar dependencias
flutter pub get
```

## Ejecutar
```bash
# Con un emulador o celular conectado:
flutter run
```
Ver dispositivos disponibles: `flutter devices`

## Probar la APK directamente
La APK ya viene compilada en la raiz de esta carpeta:
```
app-release.apk
```
Instalar en un celular Android (depuracion USB activada):
```bash
flutter install
# o manualmente:
adb install app-release.apk
```
Generar la APK de nuevo:
```bash
flutter build apk --release
# salida: build/app/outputs/flutter-apk/app-release.apk
```

---

## Como usar la app
| Accion | Que hace |
|--------|----------|
| Barra de busqueda | Filtra correos por **asunto** o **remitente**. |
| Badge "N no leidos" | Tap → marca **todos** como leidos. |
| Boton **Redactar** | Formulario simulado; crea el correo enviado. |
| **FAB (+)** | Simula la **recepcion** de un correo nuevo. |
| Tap en un correo | Lo marca como **leido**. |

Toda la UI se actualiza con **Provider** (`ChangeNotifier` + `notifyListeners`).

## Arquitectura (MVVM)
```
lib/
├── models/correo.dart                 # MODEL
├── viewmodels/correo_viewmodel.dart   # VIEWMODEL (logica + estado)
├── views/home_page.dart               # VIEW (pantalla + dialogos)
├── widgets/gmail_widget.dart          # WIDGET (UI tipo Gmail)
└── main.dart                          # MultiProvider + MaterialApp
```

## Fases del laboratorio
- **Fase 1** — Prototipo simulado (este proyecto + APK). ✓
- **Fase 2** — Conexion real con Gmail (Gmail API + OAuth):
  documentada en [FASE2_Gmail_API.md](FASE2_Gmail_API.md).
