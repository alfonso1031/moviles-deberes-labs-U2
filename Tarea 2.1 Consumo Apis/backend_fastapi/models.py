from typing import Optional, List
from sqlmodel import SQLModel, Field, Relationship


class Destino(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    nombre: str
    comunidad: str
    descripcion: str
    precio: float

    reservas: List["Reserva"] = Relationship(back_populates="destino")


class Reserva(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    destino_id: int = Field(foreign_key="destino.id")
    nombre_turista: str
    fecha: str
    num_personas: int

    destino: Optional[Destino] = Relationship(back_populates="reservas")


class DestinoCreate(SQLModel):
    nombre: str
    comunidad: str
    descripcion: str
    precio: float


class DestinoRead(SQLModel):
    id: int
    nombre: str
    comunidad: str
    descripcion: str
    precio: float


class ReservaCreate(SQLModel):
    destino_id: int
    nombre_turista: str
    fecha: str
    num_personas: int


class ReservaRead(SQLModel):
    id: int
    destino_id: int
    nombre_turista: str
    fecha: str
    num_personas: int
