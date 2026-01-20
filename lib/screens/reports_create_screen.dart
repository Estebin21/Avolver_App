import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../features/routes/routes_models.dart';
import '../features/routes/routes_service.dart';
import '../features/reports/reports_service.dart';

class ReportsCreateScreen extends StatefulWidget {
  const ReportsCreateScreen({super.key});

  @override
  State<ReportsCreateScreen> createState() => _ReportsCreateScreenState();
}

class _ReportsCreateScreenState extends State<ReportsCreateScreen> {
  final _routesService = RoutesService();
  final _reportsService = ReportsService();

  bool _loadingRoutes = true;
  bool _submitting = false;
  String? _error;

  List<RouteSummary> _routes = [];
  RouteSummary? _selectedRoute;

  final _motivoCtrl = TextEditingController();
  final _retrasoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  @override
  void dispose() {
    _motivoCtrl.dispose();
    _retrasoCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    setState(() {
      _loadingRoutes = true;
      _error = null;
    });

    try {
      final routes = await _routesService.listRoutes();
      if (!mounted) return;
      setState(() {
        _routes = routes;
        _selectedRoute = routes.isNotEmpty ? routes.first : null;
        _loadingRoutes = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loadingRoutes = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay rutas disponibles.')),
      );
      return;
    }

    final motivo = _motivoCtrl.text.trim();
    final retraso = int.tryParse(_retrasoCtrl.text.trim());

    if (motivo.isEmpty || retraso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa motivo y retraso estimado (número).')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      await _reportsService.createReport(
        rutaId: _selectedRoute!.id,
        motivo: motivo,
        retrasoEstimado: retraso,
      );

      if (!mounted) return;

      // ✅ volvemos a la pantalla anterior (menú reportes)
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte generado correctamente.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Generar reporte',
      subtitle: 'Selecciona una ruta y registra el motivo',
      bottom: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (_loadingRoutes || _submitting) ? null : _submit,
          child: _submitting
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Enviar reporte'),
        ),
      ),
      child: _loadingRoutes
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _loadRoutes, child: const Text('Reintentar')),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    const Text('Ruta', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),

                    // ✅ muestra NOMBRE pero guarda ID
                    DropdownButtonFormField<RouteSummary>(
                      value: _selectedRoute,
                      items: _routes
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedRoute = v),
                      decoration: const InputDecoration(),
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: _motivoCtrl,
                      decoration: const InputDecoration(labelText: 'Motivo'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _retrasoCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Retraso estimado (min)'),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _submitting ? null : _loadRoutes,
                        child: const Text('Recargar rutas'),
                      ),
                    ),
                  ],
                ),
    );
  }
}
