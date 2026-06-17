import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/correo_viewmodel.dart';
import '../models/correo.dart';

/// Widget (capa WIDGET del patron MVVM).
/// Componente visual tipo Gmail reutilizable.
class GmailWidget extends StatelessWidget {
  final VoidCallback onBuscarTap;
  final VoidCallback onRedactarTap;
  final VoidCallback onNoLeidosTap;

  const GmailWidget({
    super.key,
    required this.onBuscarTap,
    required this.onRedactarTap,
    required this.onNoLeidosTap,
  });

  @override
  Widget build(BuildContext context) {
    // Escucha al ViewModel: se redibuja cuando cambian los datos.
    final vm = context.watch<CorreoViewModel>();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado tipo Gmail
            Row(
              children: [
                const Icon(Icons.mail, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Gmail',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Contador de no leidos
                InkWell(
                  onTap: onNoLeidosTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${vm.noLeidos} no leidos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Barra de busqueda
            InkWell(
              onTap: onBuscarTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      vm.filtro.isEmpty
                          ? 'Buscar en el correo'
                          : 'Filtro: ${vm.filtro}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Lista de correos
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: vm.correos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Sin correos.')),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: vm.correos.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final Correo c = vm.correos[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor:
                                c.leido ? Colors.grey : Colors.red,
                            child: Text(
                              c.inicial,
                              style:
                                  const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            c.remitente,
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
                            style: TextStyle(
                              fontWeight: c.leido
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          trailing: c.leido
                              ? null
                              : const Icon(Icons.circle,
                                  color: Colors.red, size: 10),
                          onTap: () => context
                              .read<CorreoViewModel>()
                              .marcarLeido(c.id),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),

            // Boton redactar
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onRedactarTap,
                icon: const Icon(Icons.edit),
                label: const Text('Redactar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
