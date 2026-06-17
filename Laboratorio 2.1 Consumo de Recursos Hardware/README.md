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

1. Crea una clave en Google Cloud Console (habilita "Maps SDK for Android").
2. En `android/app/src/main/AndroidManifest.xml` reemplaza `TU_API_KEY`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="TU_API_KEY" />
   ```

## Ejecutar
```bash
flutter pub get
flutter run
```
Usar un dispositivo fisico (camara y GPS no funcionan bien en emulador sin
configuracion extra).

## Aprendizajes
Uso de camara, manejo de permisos en tiempo de ejecucion y geolocalizacion.
