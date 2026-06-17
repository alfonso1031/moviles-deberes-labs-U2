import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reserva.dart';

class ReservaService {
  final String baseUrl = "http://10.40.52.115:8000";

  Future<List<Reserva>> porDestino(int destinoId) async {
    final resp =
        await http.get(Uri.parse("$baseUrl/destinos/$destinoId/reservas"));
    if (resp.statusCode != 200) throw Exception("Error al cargar reservas");
    final List data = jsonDecode(resp.body);
    return data.map((e) => Reserva.fromJson(e)).toList();
  }

  Future<Reserva> crear(Reserva r) async {
    final resp = await http.post(
      Uri.parse("$baseUrl/reservas"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(r.toJson()),
    );
    if (resp.statusCode == 400) {
      throw Exception(jsonDecode(resp.body)["detail"] ?? "Error");
    }
    if (resp.statusCode != 201) throw Exception("Error al crear reserva");
    return Reserva.fromJson(jsonDecode(resp.body));
  }

  Future<void> eliminar(int id) async {
    final resp = await http.delete(Uri.parse("$baseUrl/reservas/$id"));
    if (resp.statusCode != 200) throw Exception("Error al eliminar reserva");
  }
}
