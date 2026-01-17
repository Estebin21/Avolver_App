import 'package:flutter/material.dart';
import '../services/routes_service.dart';

class RoutesScreen extends StatefulWidget {
  static const route = '/routes';
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = RoutesService.listarRutas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutas')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snap.error}'),
              ),
            );
          }

          final routes = snap.data ?? [];
          if (routes.isEmpty) {
            return const Center(child: Text('No hay rutas'));
          }

          return ListView.separated(
            itemCount: routes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = routes[i];

              // Intento leer campos comunes:
              final nombre = (r is Map && r['nombre'] != null)
                  ? r['nombre'].toString()
                  : 'Ruta ${i + 1}';

              final id = (r is Map && (r['_id'] ?? r['id']) != null)
                  ? (r['_id'] ?? r['id']).toString()
                  : null;

              return ListTile(
                title: Text(nombre),
                subtitle: Text(id != null ? 'ID: $id' : 'Sin ID'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Cuando me confirmes el endpoint correcto para paradas/ETA,
                  // aquí navegamos al detalle de ruta/paradas.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Seleccionaste: $nombre')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
