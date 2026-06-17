class Reserva {
  final int id;
  final int destinoId;
  final String nombreTurista;
  final String fecha;
  final int numPersonas;

  Reserva({
    required this.id,
    required this.destinoId,
    required this.nombreTurista,
    required this.fecha,
    required this.numPersonas,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json["id"],
      destinoId: json["destino_id"],
      nombreTurista: json["nombre_turista"],
      fecha: json["fecha"],
      numPersonas: json["num_personas"],
    );
  }

  Map<String, dynamic> toJson() => {
        "destino_id": destinoId,
        "nombre_turista": nombreTurista,
        "fecha": fecha,
        "num_personas": numPersonas,
      };
}
