class MockRoute {
  final int id;
  final String nombre;
  final String origen;
  final String destino;
  final String horario;
  final List<String> paradas;

  MockRoute({
    required this.id,
    required this.nombre,
    required this.origen,
    required this.destino,
    required this.horario,
    required this.paradas,
  });
}

class MockReport {
  final int rutaId;
  final String motivo;
  final int retrasoEstimadoMin;

  MockReport({
    required this.rutaId,
    required this.motivo,
    required this.retrasoEstimadoMin,
  });
}

final mockRoutes = <MockRoute>[
  MockRoute(
    id: 1,
    nombre: 'Ruta Norte',
    origen: 'Terminal A',
    destino: 'Terminal B',
    horario: '06:00 - 22:00',
    paradas: ['Parada La Carolina', 'Parada El Ejido', 'Parada La Mariscal', 'Parada Terminal B'],
  ),
  MockRoute(
    id: 2,
    nombre: 'Ruta Sur',
    origen: 'Terminal C',
    destino: 'Terminal D',
    horario: '05:30 - 21:30',
    paradas: ['Parada Quitumbe', 'Parada Chillogallo', 'Parada Atahualpa', 'Parada Terminal D'],
  ),
  MockRoute(
    id: 3,
    nombre: 'Ruta Centro',
    origen: 'Estación X',
    destino: 'Estación Y',
    horario: '07:00 - 20:00',
    paradas: ['Parada Centro Histórico', 'Parada Alameda', 'Parada Itchimbía', 'Parada Estación Y'],
  ),
];

final mockReports = <MockReport>[
  MockReport(rutaId: 1, motivo: 'Tráfico', retrasoEstimadoMin: 15),
  MockReport(rutaId: 2, motivo: 'Accidente leve', retrasoEstimadoMin: 25),
];
