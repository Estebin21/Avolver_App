import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../widgets/brand_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandScaffold(
      showBack: false,
      title: 'Menú principal',
      subtitle: 'Elige una opción para continuar',
      child: ListView(
        children: [
          _MenuCard(
            icon: Icons.bar_chart_rounded,
            title: 'Reportes',
            description: 'Consulta y genera reportes de retrasos.',
            color: Theme.of(context).colorScheme.primary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.reportsMenu),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            icon: Icons.directions_bus_rounded,
            title: 'Rutas',
            description: 'Explora rutas, paradas y tu tiempo estimado.',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.routesList),
          ),
          const SizedBox(height: 18),

          // “Tip” para que se vea más app real
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                    ),
                    child: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tip: En “Rutas” puedes seleccionar una parada para ver el tiempo estimado.',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: color.withOpacity(0.12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
