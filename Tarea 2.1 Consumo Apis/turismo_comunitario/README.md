# turismo_comunitario

App Flutter (MVVM + Provider) que consume la API REST de Turismo Comunitario.

La guia completa de instalacion y ejecucion esta en el README de la carpeta
superior: `../README.md`.

## Resumen rapido

```bash
flutter pub get
flutter run
```

El backend FastAPI debe estar corriendo. Configura la URL de la API en
`lib/services/destino_service.dart` y `lib/services/reserva_service.dart`.

## Estructura (MVVM)

- `lib/models/` — entidades (Destino, Reserva)
- `lib/services/` — consumo HTTP de la API
- `lib/viewmodels/` — estado y logica (ChangeNotifier)
- `lib/views/` — pantallas (splash, lista, detalle, formularios)
- `lib/widgets/` — componentes reutilizables
