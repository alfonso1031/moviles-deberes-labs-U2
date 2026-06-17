# Laboratorio 2.1 - Camara Turistica con Geolocalizacion

App Flutter que captura fotografias y guarda automaticamente la ubicacion GPS
donde fueron tomadas, mostrando cada punto en Google Maps.

## Funcionalidades
- Tomar fotografia con la camara del dispositivo.
- Obtener latitud y longitud (GPS) al momento de la captura.
- Mostrar la ubicacion en Google Maps (mapa general y por foto).
- Guardar historial de fotografias (ListView con miniaturas + coordenadas).

## Paquetes
- `image_picker` — acceso a la camara (uso de hardware + permisos).
- `geolocator` — geolocalizacion (latitud/longitud).
- `google_maps_flutter` — widget GoogleMap con marcadores.
- `provider` — manejo de estado.

## Arquitectura (MVC + Provider)
```
lib/
  models/foto.dart             -> modelo Foto (path, nombre, lat, lng, fecha)
  providers/foto_provider.dart -> estado: historial de fotos (ChangeNotifier)
  controllers/foto_controller  -> logica: permisos GPS + captura de foto
  views/
    home_view.dart             -> pantalla de inicio
    foto_view.dart             -> camara + ListView del historial
    mapa_view.dart             -> mapa con todos los marcadores
    mapa_detalle_view.dart     -> mapa de una sola foto
  widgets/foto_item.dart       -> tarjeta de cada foto en la lista
```

## Configuracion de Google Maps (IMPORTANTE)
El mapa no se mostrara hasta colocar una clave de API valida.
La clave NO va en el codigo: se carga desde un archivo gitignored e inyectada
por Gradle al AndroidManifest (`${MAPS_API_KEY}`).

1. Crea una clave en Google Cloud Console (habilita "Maps SDK for Android").
2. Copia el ejemplo y pon tu clave real:
   ```bash
   cp android/secrets.properties.example android/secrets.properties
   ```
   ```properties
   # android/secrets.properties
   MAPS_API_KEY=AIza...tu_clave
   ```
3. `flutter run`. Gradle lee `secrets.properties` y rellena la clave.

`android/secrets.properties` esta en `.gitignore`, asi la clave nunca se sube.

## Requisitos previos
- Flutter SDK 3.x y Dart 3.x (`flutter --version`).
- Android Studio o VS Code con el plugin de Flutter.
- Un dispositivo Android **fisico** con depuracion USB activada (la camara y el
  GPS no funcionan bien en emulador).
- Una clave de API de Google Maps (ver seccion anterior).

## Instalacion y ejecucion (paso a paso)
1. Clonar o descargar el repositorio y entrar a la carpeta del proyecto:
   ```bash
   cd "Laboratorio 2.1 Consumo de Recursos Hardware"
   ```
2. Instalar las dependencias:
   ```bash
   flutter pub get
   ```
3. Configurar la clave de Google Maps:
   ```bash
   cp android/secrets.properties.example android/secrets.properties
   # editar android/secrets.properties y poner: MAPS_API_KEY=AIza...tu_clave
   ```
4. Conectar el celular por USB y verificar que Flutter lo detecta:
   ```bash
   flutter devices
   ```
5. Ejecutar la app en el dispositivo:
   ```bash
   flutter run
   ```
6. Al primer uso, **aceptar los permisos** de camara y ubicacion que pide el sistema,
   y mantener el **GPS encendido**.

### Comandos utiles
```bash
flutter analyze      # analisis estatico (sin errores)
flutter clean        # limpiar build si el mapa no carga tras cambiar la clave
flutter build apk    # generar APK de instalacion
```

### Solucion de problemas
- **Mapa en gris**: clave invalida, sin "Maps SDK for Android" habilitado, o sin
  facturacion. Tras corregir, ejecutar `flutter clean` y volver a `flutter run`.
- **No obtiene ubicacion**: activar el GPS y conceder el permiso de ubicacion.
- **La camara no abre**: conceder el permiso de camara en los ajustes de la app.

## Aprendizajes
Uso de camara, manejo de permisos en tiempo de ejecucion y geolocalizacion.
