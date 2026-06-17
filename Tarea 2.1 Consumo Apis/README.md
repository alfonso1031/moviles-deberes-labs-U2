# Tarea 2.1 — Consumo de APIs · Turismo Comunitario

Aplicacion movil en **Flutter** que consume una **API REST (FastAPI + SQLite)** para gestionar destinos de turismo comunitario y sus reservas.

Arquitectura **MVVM** con **Provider / MultiProvider**.

## Entidades

- **Destino** — nombre, comunidad, descripcion, precio.
- **Reserva** — nombre del turista, fecha, numero de personas (pertenece a un destino).

## Reglas de negocio

- Un destino puede tener muchas reservas.
- No se puede registrar una reserva en una fecha pasada.
- La reserva exige nombre del turista, fecha y numero de personas.
- No se puede eliminar un destino que tenga reservas registradas.

## Estructura

```
Tarea 2.1 Consumo Apis/
├─ backend_fastapi/        API REST (FastAPI + SQLite)
│  ├─ main.py              endpoints y reglas de negocio
│  ├─ models.py            Destino y Reserva (relacion 1-N)
│  ├─ database.py          conexion SQLite
│  └─ requirements.txt
└─ turismo_comunitario/    App Flutter (MVVM)
   └─ lib/
      ├─ models/           entidades
      ├─ services/         consumo HTTP de la API
      ├─ viewmodels/       logica + estado (ChangeNotifier)
      ├─ widgets/          tarjetas reutilizables
      └─ views/            splash, lista, detalle, formularios
```

---

## 1. Backend (FastAPI)

Requiere **Python 3.10+**.

Desde la carpeta `backend_fastapi`:

```bash
python -m venv venv
venv\Scripts\python.exe -m pip install -r requirements.txt
venv\Scripts\python.exe -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

- API: `http://localhost:8000`
- Documentacion interactiva (probar el CRUD): `http://localhost:8000/docs`

La base de datos `turismo.db` se crea sola al iniciar, con datos de ejemplo.

### Endpoints

| Metodo | Ruta                    | Descripcion                        |
|--------|-------------------------|------------------------------------|
| GET    | /destinos               | Listar destinos                    |
| GET    | /destinos/{id}          | Obtener un destino                 |
| POST   | /destinos               | Crear destino                      |
| PUT    | /destinos/{id}          | Actualizar destino                 |
| DELETE | /destinos/{id}          | Eliminar (falla si tiene reservas) |
| GET    | /destinos/{id}/reservas | Reservas de un destino             |
| POST   | /reservas               | Crear reserva (valida fecha)       |
| DELETE | /reservas/{id}          | Eliminar reserva                   |

---

## 2. App Flutter

Requiere **Flutter SDK** (canal stable).

Desde la carpeta `turismo_comunitario`:

```bash
flutter pub get
flutter run
```

### Configurar la URL de la API

El backend debe estar corriendo. Edita la URL en:

- `lib/services/destino_service.dart`
- `lib/services/reserva_service.dart`

Segun donde corras la app:

| Dispositivo               | baseUrl                       |
|---------------------------|-------------------------------|
| Chrome / Windows          | `http://localhost:8000`       |
| Emulador Android          | `http://10.0.2.2:8000`        |
| Celular fisico (misma WiFi)| `http://<IP_DEL_PC>:8000`    |

Para el celular: ejecuta `ipconfig` en el PC, copia la IPv4 y usala. El PC y el celular deben estar en la misma red WiFi, y el backend lanzado con `--host 0.0.0.0`.

---

## Pantallas

- **Splash Screen** con animacion.
- **Lista de destinos** (ListView) con pull-to-refresh.
- **Detalle del destino** con sus reservas.
- **Formulario de reserva** (selector de fecha que bloquea fechas pasadas).
- **Registro/edicion de destinos**.
