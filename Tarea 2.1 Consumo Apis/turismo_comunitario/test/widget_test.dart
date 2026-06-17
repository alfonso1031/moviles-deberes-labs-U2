import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_comunitario/models/destino.dart';
import 'package:turismo_comunitario/models/reserva.dart';

void main() {
  test("Destino se mapea desde y hacia JSON", () {
    final json = {
      "id": 1,
      "nombre": "Quilotoa",
      "comunidad": "Zumbahua",
      "descripcion": "Laguna volcanica",
      "precio": 25.0,
    };
    final d = Destino.fromJson(json);
    expect(d.nombre, "Quilotoa");
    expect(d.precio, 25.0);
    expect(d.toJson()["comunidad"], "Zumbahua");
  });

  test("Reserva se mapea desde y hacia JSON", () {
    final json = {
      "id": 5,
      "destino_id": 2,
      "nombre_turista": "Ana",
      "fecha": "2026-07-01",
      "num_personas": 3,
    };
    final r = Reserva.fromJson(json);
    expect(r.destinoId, 2);
    expect(r.numPersonas, 3);
    expect(r.toJson()["nombre_turista"], "Ana");
  });
}
