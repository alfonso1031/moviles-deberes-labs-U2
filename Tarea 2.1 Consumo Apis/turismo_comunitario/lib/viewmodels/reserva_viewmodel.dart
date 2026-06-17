import 'package:flutter/material.dart';
import '../models/reserva.dart';
import '../services/reserva_service.dart';

class ReservaViewModel extends ChangeNotifier {
  final ReservaService service;

  ReservaViewModel({required this.service});

  List<Reserva> reservas = [];
  bool loading = false;
  String? errorMessage;

  Future<void> cargarPorDestino(int destinoId) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      reservas = await service.porDestino(destinoId);
    } catch (e) {
      errorMessage = "$e";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<String?> crear(Reserva r) async {
    try {
      await service.crear(r);
      await cargarPorDestino(r.destinoId);
      return null;
    } catch (e) {
      return e.toString().replaceFirst("Exception: ", "");
    }
  }

  Future<String?> actualizar(int id, Reserva r) async {
    try {
      await service.actualizar(id, r);
      await cargarPorDestino(r.destinoId);
      return null;
    } catch (e) {
      return e.toString().replaceFirst("Exception: ", "");
    }
  }

  Future<bool> eliminar(int id, int destinoId) async {
    try {
      await service.eliminar(id);
      await cargarPorDestino(destinoId);
      return true;
    } catch (e) {
      errorMessage = "$e";
      notifyListeners();
      return false;
    }
  }
}
