class RouteSummary {
  final String id;
  final String nombre;
  final int? frecuencia;

  RouteSummary({
    required this.id,
    required this.nombre,
    this.frecuencia,
  });

  factory RouteSummary.fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString();

    // ⚠️ intenta varios nombres posibles por si el backend usa otra key
    final nombre = (json['nombre'] ??
            json['name'] ??
            json['ruta'] ??
            json['nombreRuta'] ??
            'Ruta')
        .toString();

    final frecuencia =
        (json['frecuencia'] is num) ? (json['frecuencia'] as num).toInt() : null;

    return RouteSummary(
      id: id,
      nombre: nombre,
      frecuencia: frecuencia,
    );
  }
}


class StopInfo {
  final String nombre;
  final String callePrincipal;
  final String calleSecundaria;
  final dynamic tiempo; // puede ser int/double/string según backend

  StopInfo({
    required this.nombre,
    required this.callePrincipal,
    required this.calleSecundaria,
    this.tiempo,
  });

  factory StopInfo.fromJson(Map<String, dynamic> json) {
  dynamic rawTiempo = json['tiempo'] ??
      json['tiempoEstimado'] ??
      json['tiempo_estimado'] ??
      json['eta'] ??
      json['minutos'] ??
      json['tiempoMin'];

  // Normaliza a int si viene string/número
  int? tiempoMin;
  if (rawTiempo != null) {
    if (rawTiempo is num) {
      tiempoMin = rawTiempo.toInt();
    } else {
      final parsed = int.tryParse(rawTiempo.toString());
      tiempoMin = parsed;
    }
  }

  return StopInfo(
    nombre: (json['nombre'] ?? json['name'] ?? '').toString(),
    callePrincipal: (json['callePrincipal'] ?? json['calle_principal'] ?? '').toString(),
    calleSecundaria: (json['calleSecundaria'] ?? json['calle_secundaria'] ?? '').toString(),
    tiempo: tiempoMin, // 👈 ahora queda limpio
  );
}
}

class RouteDetail {
  final String id;
  final List<StopInfo> paradas;

  RouteDetail({required this.id, required this.paradas});

  factory RouteDetail.fromJson(Map<String, dynamic> json) {
    // Soporta varias posibles claves para paradas
    final rawStops = (json['paradas'] ?? json['stops'] ?? json['Paradas'] ?? []) as List<dynamic>;
    return RouteDetail(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      paradas: rawStops.whereType<Map>().map((e) => StopInfo.fromJson(e.cast<String, dynamic>())).toList(),
    );
  }
}
