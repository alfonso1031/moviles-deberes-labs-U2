# API REST - Turismo Comunitario (FastAPI + SQLite)

API REST con dos entidades relacionadas: **Destino** y **Reserva**. Persistencia en SQLite (`turismo.db`).

## Requisitos

- Python 3.10+

## Instalacion y ejecucion

Desde la carpeta `backend_fastapi`:

```powershell
python -m venv venv
venv\Scripts\python.exe -m pip install -r requirements.txt
venv\Scripts\python.exe -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Servidor: `http://localhost:8000`  ·  Docs: `http://localhost:8000/docs`

## Reglas de negocio

- Un destino puede tener muchas reservas.
- No se puede registrar una reserva en una fecha pasada.
- La reserva exige nombre del turista, fecha y numero de personas.
- No se puede eliminar un destino que tenga reservas registradas.

## Endpoints

| Metodo | Ruta                      | Descripcion                          |
|--------|---------------------------|--------------------------------------|
| GET    | /destinos                 | Listar destinos                      |
| GET    | /destinos/{id}            | Obtener un destino                   |
| POST   | /destinos                 | Crear destino                        |
| PUT    | /destinos/{id}            | Actualizar destino                   |
| DELETE | /destinos/{id}            | Eliminar (falla si tiene reservas)   |
| GET    | /destinos/{id}/reservas   | Reservas de un destino               |
| GET    | /reservas                 | Listar todas las reservas            |
| POST   | /reservas                 | Crear reserva (valida fecha)         |
| DELETE | /reservas/{id}            | Eliminar reserva                     |

## Conexion desde Flutter

- Chrome / Windows: `http://localhost:8000`
- Celular fisico (misma WiFi): `http://<IP_DEL_PC>:8000`

URL configurada en `lib/services/destino_service.dart` y `lib/services/reserva_service.dart`.
