import 'package:flutter/material.dart';
import '../models/correo.dart';

/// Pantalla de detalle de correo.
/// [bodyFuture]: null = correo simulado (usa correo.cuerpo).
///               non-null = correo real (fetch asincronico del cuerpo).
class CorreoDetallePage extends StatelessWidget {
  final Correo correo;
  final Future<String>? bodyFuture;

  const CorreoDetallePage({
    super.key,
    required this.correo,
    this.bodyFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('Correo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Asunto
            Text(
              correo.asunto,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Remitente + fecha
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(correo.inicial,
                      style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(correo.remitente,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(
                        _formatFecha(correo.fecha),
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Cuerpo
            bodyFuture == null
                ? _cuerpoSimulado(correo.cuerpo)
                : _cuerpoReal(),
          ],
        ),
      ),
    );
  }

  Widget _cuerpoSimulado(String cuerpo) {
    return Text(cuerpo, style: const TextStyle(fontSize: 15, height: 1.5));
  }

  Widget _cuerpoReal() {
    return FutureBuilder<String>(
      future: bodyFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Text('Error al cargar: ${snap.error}',
              style: const TextStyle(color: Colors.red));
        }
        final texto = snap.data ?? '';
        return Text(
          texto.isEmpty ? '(sin contenido)' : texto,
          style: const TextStyle(fontSize: 15, height: 1.5),
        );
      },
    );
  }

  String _formatFecha(DateTime f) {
    final now = DateTime.now();
    if (f.year == now.year && f.month == now.month && f.day == now.day) {
      return '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';
    }
    return '${f.day}/${f.month}/${f.year}';
  }
}
