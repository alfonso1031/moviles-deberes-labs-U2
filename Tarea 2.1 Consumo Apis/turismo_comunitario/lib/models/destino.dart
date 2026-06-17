class Destino {
  final int id;
  final String nombre;
  final String comunidad;
  final String descripcion;
  final double precio;

  Destino({
    required this.id,
    required this.nombre,
    required this.comunidad,
    required this.descripcion,
    required this.precio,
  });

  factory Destino.fromJson(Map<String, dynamic> json) {
    return Destino(
      id: json["id"],
      nombre: json["nombre"],
      comunidad: json["comunidad"],
      descripcion: json["descripcion"],
      precio: (json["precio"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "comunidad": comunidad,
        "descripcion": descripcion,
        "precio": precio,
      };
}
