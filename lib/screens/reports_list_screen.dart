import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../features/reports/reports_models.dart';
import '../features/reports/reports_service.dart';
import '../features/routes/routes_service.dart';
import '../features/routes/routes_models.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  final _reportsService = ReportsService();
  final _routesService = RoutesService();

  bool _loading = true;
  String? _error;

  List<ReportItem> _reports = [];
  Map<String, String> _routeNamesById = {};

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 🔹 cargar rutas y reportes en paralelo
      final results = await Future.wait([
        _routesService.listRoutes(),
        _reportsService.listReports(),
      ]);

      final routes = results[0] as List<RouteSummary>;
      final reports = results[1] as List<ReportItem>;

      final routeMap = {
        for (final r in routes) r.id: r.nombre,
      };

      if (!mounted) return;
      setState(() {
        _routeNamesById = routeMap;
        _reports = reports;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  String _routeName(String routeId) {
    return _routeNamesById[routeId] ?? 'Ruta desconocida';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Reportes',
      subtitle: 'Lista de reportes registrados',
      bottom: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _loadAll,
          child: const Text('Actualizar'),
        ),
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _loadAll, child: const Text('Reintentar')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAll,
                  child: ListView.separated(
                    itemCount: _reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final r = _reports[i];
                      final routeName = _routeName(r.rutaId);

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: ListTile(
                          title: Text(
                            r.motivo,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '$routeName\nRetraso estimado: ${r.retrasoEstimado} min',
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
