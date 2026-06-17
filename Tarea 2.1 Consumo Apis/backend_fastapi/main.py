from datetime import date
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlmodel import Session, select
from database import crear_tablas, get_session, engine
from models import (
    Destino, DestinoCreate, DestinoRead,
    Reserva, ReservaCreate, ReservaRead,
)

app = FastAPI(title="API Turismo Comunitario")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def startup():
    crear_tablas()
    _seed()


def _seed():
    with Session(engine) as s:
        if s.exec(select(Destino)).first():
            return
        destinos = [
            Destino(nombre="Laguna de Quilotoa", comunidad="Quilotoa",
                    descripcion="Laguna volcanica de aguas turquesa en los Andes",
                    precio=25.0),
            Destino(nombre="Comunidad Agua Blanca", comunidad="Machalilla",
                    descripcion="Aldea ancestral con laguna de azufre y museo",
                    precio=15.0),
            Destino(nombre="Saraguro Vivencial", comunidad="Saraguro",
                    descripcion="Turismo vivencial con familias indigenas kichwa",
                    precio=30.0),
            Destino(nombre="Isla de los Monos", comunidad="Cuyabeno",
                    descripcion="Reserva amazonica con fauna y guias locales",
                    precio=45.0),
        ]
        for d in destinos:
            s.add(d)
        s.commit()


# ── Destinos ──────────────────────────────────────────────

@app.get("/destinos", response_model=list[DestinoRead])
def listar_destinos(session: Session = Depends(get_session)):
    return session.exec(select(Destino)).all()


@app.get("/destinos/{id}", response_model=DestinoRead)
def obtener_destino(id: int, session: Session = Depends(get_session)):
    destino = session.get(Destino, id)
    if not destino:
        raise HTTPException(status_code=404, detail="Destino no encontrado")
    return destino


@app.post("/destinos", response_model=DestinoRead, status_code=201)
def crear_destino(data: DestinoCreate, session: Session = Depends(get_session)):
    destino = Destino(**data.model_dump())
    session.add(destino)
    session.commit()
    session.refresh(destino)
    return destino


@app.put("/destinos/{id}", response_model=DestinoRead)
def actualizar_destino(id: int, data: DestinoCreate,
                       session: Session = Depends(get_session)):
    destino = session.get(Destino, id)
    if not destino:
        raise HTTPException(status_code=404, detail="Destino no encontrado")
    for k, v in data.model_dump().items():
        setattr(destino, k, v)
    session.add(destino)
    session.commit()
    session.refresh(destino)
    return destino


@app.delete("/destinos/{id}")
def eliminar_destino(id: int, session: Session = Depends(get_session)):
    destino = session.get(Destino, id)
    if not destino:
        raise HTTPException(status_code=404, detail="Destino no encontrado")
    reservas = session.exec(
        select(Reserva).where(Reserva.destino_id == id)
    ).first()
    if reservas:
        raise HTTPException(
            status_code=400,
            detail="No se puede eliminar un destino con reservas registradas"
        )
    session.delete(destino)
    session.commit()
    return {"mensaje": "Destino eliminado"}


# ── Reservas ──────────────────────────────────────────────

@app.get("/reservas", response_model=list[ReservaRead])
def listar_reservas(session: Session = Depends(get_session)):
    return session.exec(select(Reserva)).all()


@app.get("/destinos/{id}/reservas", response_model=list[ReservaRead])
def reservas_de_destino(id: int, session: Session = Depends(get_session)):
    return session.exec(
        select(Reserva).where(Reserva.destino_id == id)
    ).all()


@app.post("/reservas", response_model=ReservaRead, status_code=201)
def crear_reserva(data: ReservaCreate, session: Session = Depends(get_session)):
    destino = session.get(Destino, data.destino_id)
    if not destino:
        raise HTTPException(status_code=404, detail="Destino no encontrado")
    try:
        fecha_reserva = date.fromisoformat(data.fecha)
    except ValueError:
        raise HTTPException(status_code=400, detail="Fecha invalida")
    if fecha_reserva < date.today():
        raise HTTPException(
            status_code=400,
            detail="No se puede reservar en una fecha pasada"
        )
    if data.num_personas < 1:
        raise HTTPException(
            status_code=400,
            detail="El numero de personas debe ser al menos 1"
        )
    reserva = Reserva(**data.model_dump())
    session.add(reserva)
    session.commit()
    session.refresh(reserva)
    return reserva


@app.delete("/reservas/{id}")
def eliminar_reserva(id: int, session: Session = Depends(get_session)):
    reserva = session.get(Reserva, id)
    if not reserva:
        raise HTTPException(status_code=404, detail="Reserva no encontrada")
    session.delete(reserva)
    session.commit()
    return {"mensaje": "Reserva eliminada"}
