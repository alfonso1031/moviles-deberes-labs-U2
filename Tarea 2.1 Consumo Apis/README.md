# Tarea 2.1 — Consumo de APIs · Turismo Comunitario

Aplicacion movil en **Flutter** que consume una **API REST (FastAPI + SQLite)** para
gestionar destinos de turismo comunitario y sus reservas.

Arquitectura **MVVM** con **Provider / MultiProvider**.

---

## Contenido

1. [Entidades y reglas de negocio](#entidades)
2. [Estructura del proyecto](#estructura)
3. [Requisitos](#requisitos)
4. [Ejecutar el backend (FastAPI)](#backend)
5. [Ver y probar los endpoints](#endpoints)
6. [Ejecutar la app (Flutter)](#flutter)
7. [Configurar la IP del servidor](#ip)
8. [Solucion de problemas](#problemas)

---

<a name="entidades"></a>
## 1. Entidades y reglas de negocio

**Entidades**

- **Destino** — nombre, comunidad, descripcion, precio.
- **Reserva** — nombre del turista, fecha, numero de personas (pertenece a un destino).

**Reglas de negocio**

- Un destino puede tener muchas reservas.
- No se puede registrar una reserva en una fecha pasada.
- La reserva exige nombre del turista, fecha y numero de personas.
- No se puede eliminar un destino que tenga reservas registradas.

---

<a name="estructura"></a>
## 2. Estructura del proyecto

```
Tarea 2.1 Consumo Apis/
├─ backend_fastapi/          API REST (FastAPI + SQLite)
│  ├─ main.py                endpoints + reglas de negocio
│  ├─ models.py              Destino y Reserva (relacion 1-N)
│  ├─ database.py            conexion SQLite
│  └─ requirements.txt
└─ turismo_comunitario/      App Flutter (MVVM)
   └─ lib/
      ├─ models/             entidades (Destino, Reserva)
      ├─ services/           consumo HTTP de la API
      ├─ viewmodels/         estado y logica (ChangeNotifier)
      ├─ views/              splash, lista, detalle, formularios
      └─ widgets/            tarjetas reutilizables
```

---

<a name="requisitos"></a>
## 3. Requisitos

- **Python 3.10+** (para el backend)
- **Flutter SDK** canal stable (para la app)
- PC y celular en la **misma red WiFi** (si corres en celular fisico)

---

<a name="backend"></a>
## 4. Ejecutar el backend (FastAPI)

Abre una terminal en la carpeta `backend_fastapi`.

**Primera vez** (crea entorno virtual e instala dependencias):

```bash
python -m venv venv
venv\Scripts\python.exe -m pip install -r requirements.txt
```

**Levantar el servidor** (siempre que vayas a usar la app):

```bash
venv\Scripts\python.exe -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Cuando veas `Application startup complete`, el servidor esta listo en el puerto 8000.
La base de datos `turismo.db` se crea sola con datos de ejemplo.

> Deja esta terminal abierta mientras uses la app. Si cierras el servidor, la app
> mostrara "Error de conexion".

---

<a name="endpoints"></a>
## 5. Ver y probar los endpoints

Con el servidor corriendo, abre en el navegador:

```
http://localhost:8000/docs
```

Es la documentacion interactiva (Swagger). Ahi puedes probar **todo el CRUD** sin
Postman: clic en un endpoint → **Try it out** → llena los datos → **Execute**.

### Endpoints disponibles

| Metodo | Ruta                      | Descripcion                          |
|--------|---------------------------|--------------------------------------|
| GET    | /destinos                 | Listar destinos                      |
| GET    | /destinos/{id}            | Obtener un destino                   |
| POST   | /destinos                 | Crear destino                        |
| PUT    | /destinos/{id}            | Actualizar destino                   |
| DELETE | /destinos/{id}            | Eliminar (falla si tiene reservas)   |
| GET    | /destinos/{id}/reservas   | Reservas de un destino               |
| GET    | /reservas                 | Listar todas las reservas            |
| GET    | /reservas/{id}            | Obtener una reserva                  |
| POST   | /reservas                 | Crear reserva (valida fecha)         |
| PUT    | /reservas/{id}            | Actualizar reserva (valida fecha)    |
| DELETE | /reservas/{id}            | Eliminar reserva                     |

### Probar en Postman (opcional)

New → Import → pega `http://localhost:8000/openapi.json` → genera la coleccion
completa lista para probar.

---

<a name="flutter"></a>
## 6. Ejecutar la app (Flutter)

En **otra terminal** (deja el backend corriendo), dentro de `turismo_comunitario`:

```bash
flutter pub get
flutter run
```

O en Android Studio: selecciona el dispositivo → Run.

> Antes de configurar el dispositivo, revisa la seccion siguiente para poner la
> IP correcta del servidor.

---

<a name="ip"></a>
## 7. Configurar la IP del servidor

La app necesita saber donde esta el backend. La URL se define en **dos archivos**:

- `turismo_comunitario/lib/services/destino_service.dart`
- `turismo_comunitario/lib/services/reserva_service.dart`

Busca la linea:

```dart
final String baseUrl = "http://192.168.100.31:8000";
```

Cambia la IP segun donde corras la app:

| Dispositivo                 | baseUrl                          |
|-----------------------------|----------------------------------|
| Chrome / Windows (desktop)  | `http://localhost:8000`          |
| Emulador Android            | `http://10.0.2.2:8000`           |
| Celular fisico (misma WiFi) | `http://<IP_DEL_PC>:8000`        |

### Como saber la IP del PC (celular fisico)

1. Abre una terminal y ejecuta:
   ```bash
   ipconfig
   ```
2. Busca **Direccion IPv4** (ej. `192.168.100.31`).
3. Pon esa IP en los dos archivos `*_service.dart`.
4. Guarda y haz **hot restart** (`R` mayuscula en `flutter run`).

> La IP del PC **cambia** cada vez que te conectas a otra red WiFi. Si la app deja
> de conectar, vuelve a correr `ipconfig` y actualiza la IP.

### Verificar la conexion desde el celular

Abre el navegador del **celular** y entra a `http://<IP_DEL_PC>:8000/docs`.
Si carga la pagina → la red esta bien. Si no carga → revisa el firewall (abajo).

---

<a name="problemas"></a>
## 8. Solucion de problemas

**"Error de conexion / tiempo de espera agotado"**

- Verifica que el backend este corriendo (`Application startup complete`).
- Confirma que PC y celular esten en la **misma WiFi**.
- Asegurate que la IP en los `*_service.dart` sea la actual del PC (`ipconfig`).
- El servidor debe lanzarse con `--host 0.0.0.0` (no solo `127.0.0.1`).

**El celular no abre `http://<IP>:8000/docs` (firewall)**

Abre **PowerShell como administrador** y ejecuta una vez:

```powershell
New-NetFirewallRule -DisplayName "FastAPI 8000" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow -Profile Private,Public
```

**Pantalla negra al cambiar de pestaña**

Asegurate de usar la version actual del codigo (el formulario embebido no hace
`Navigator.pop`).
