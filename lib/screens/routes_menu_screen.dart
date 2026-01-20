import 'package:flutter/material.dart';
import '../app_routes.dart';

class RoutesMenuScreen extends StatelessWidget {
  const RoutesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.routesList),
                child: const Text('Listar rutas'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.routesList),
                child: const Text('Obtener ruta por ID'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
