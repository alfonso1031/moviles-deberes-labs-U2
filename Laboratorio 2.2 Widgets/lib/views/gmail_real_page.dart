import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/gmail_viewmodel.dart';

/// View de la Fase 2: muestra correos REALES de Gmail.
class GmailRealPage extends StatelessWidget {
  const GmailRealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GmailViewModel(),
      child: const _GmailRealView(),
    );
  }
}

class _GmailRealView extends StatelessWidget {
  const _GmailRealView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GmailViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('Gmail real (Fase 2)'),
        actions: [
          if (vm.conectado) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: vm.cargando ? null : () => vm.recargar(),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => vm.desconectar(),
            ),
          ],
        ],
      ),
      floatingActionButton: vm.conectado
          ? FloatingActionButton.extended(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.edit),
              label: const Text('Redactar'),
              onPressed: () => _redactar(context, vm),
            )
          : null,
      body: _body(context, vm),
    );
  }

  Widget _body(BuildContext context, GmailViewModel vm) {
    if (vm.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!vm.conectado) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mail, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text('Conecta tu cuenta de Gmail real'),
            if (vm.error != null) ...[
              const SizedBox(height: 8),
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.login),
              label: const Text('Iniciar sesion con Google'),
              onPressed: () => vm.conectar(),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  (vm.correoUsuario ?? '?')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vm.correoUsuario ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${vm.noLeidos} no leidos',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por asunto o remitente',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: vm.buscar,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: vm.correos.isEmpty
              ? const Center(child: Text('Sin correos.'))
              : ListView.separated(
                  itemCount: vm.correos.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final c = vm.correos[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            c.leido ? Colors.grey : Colors.red,
                        child: Text(c.inicial,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(
                        c.remitente,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: c.leido
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        c.asunto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _redactar(BuildContext context, GmailViewModel vm) {
    final dest = TextEditingController();
    final asunto = TextEditingController();
    final cuerpo = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Redactar correo real'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dest,
              decoration: const InputDecoration(labelText: 'Para (email)'),
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
              Navigator.pop(context);
              vm.enviar(
                destinatario: dest.text.trim(),
                asunto: asunto.text.trim(),
                cuerpo: cuerpo.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enviando correo real...')),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
