import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destino.dart';

class DestinoService {
  final String baseUrl = "http://192.168.100.31:8000";

  Future<List<Destino>> listar() async {
    final resp = await http.get(Uri.parse("$baseUrl/destinos"));
    if (resp.statusCode != 200) throw Exception("Error al listar destinos");
    final List data = jsonDecode(resp.body);
    return data.map((e) => Destino.fromJson(e)).toList();
  }

  Future<Destino> crear(Destino d) async {
    final resp = await http.post(
      Uri.parse("$baseUrl/destinos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(d.toJson()),
    );
    if (resp.statusCode != 201) throw Exception("Error al crear destino");
    return Destino.fromJson(jsonDecode(resp.body));
  }

  Future<Destino> actualizar(int id, Destino d) async {
    final resp = await http.put(
      Uri.parse("$baseUrl/destinos/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(d.toJson()),
    );
    if (resp.statusCode != 200) throw Exception("Error al actualizar destino");
    return Destino.fromJson(jsonDecode(resp.body));
  }

  Future<void> eliminar(int id) async {
    final resp = await http.delete(Uri.parse("$baseUrl/destinos/$id"));
    if (resp.statusCode == 400) {
      throw Exception(jsonDecode(resp.body)["detail"] ?? "No se puede eliminar");
    }
    if (resp.statusCode != 200) throw Exception("Error al eliminar destino");
  }
}
