import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../widgets/gmail_widget.dart';

/// View (capa VIEW del patron MVVM).
/// Pantalla principal que muestra el GmailWidget.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CorreoViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('Prototipo de widget'),
      ),
      body: SingleChildScrollView(
        child: GmailWidget(
          onBuscarTap: () => _mostrarBuscar(context, vm),
          onRedactarTap: () => _mostrarRedactar(context, vm),
          onNoLeidosTap: () {
            vm.marcarTodosLeidos();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Todos los correos marcados como leidos'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () => vm.recibirNuevoCorreo(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialogo de busqueda: filtra por asunto o remitente.
  void _mostrarBuscar(BuildContext context, CorreoViewModel vm) {
    final ctrl = TextEditingController(text: vm.filtro);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Buscar correo'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Asunto o remitente',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: vm.buscar,
        ),
        actions: [
          TextButton(
            onPressed: () {
              vm.buscar('');
              Navigator.pop(context);
            },
            child: const Text('Limpiar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // Dialogo de redaccion simulada de correo.
  void _mostrarRedactar(BuildContext context, CorreoViewModel vm) {
    final dest = TextEditingController();
    final asunto = TextEditingController();
    final cuerpo = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Redactar correo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dest,
              decoration: const InputDecoration(labelText: 'Para'),
            ),
            TextField(
              controller: asunto,
              decoration: const InputDecoration(labelText: 'Asunto'),
            ),
            TextField(
              controller: cuerpo,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Mensaje'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.redactarCorreo(
                destinatario: dest.text.trim(),
                asunto: asunto.text.trim(),
                cuerpo: cuerpo.text.trim(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Correo enviado (simulado)')),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
