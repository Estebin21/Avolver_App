class ReportItem {
  final String rutaId;
  final String motivo;
  final int retrasoEstimado;

  ReportItem({
    required this.rutaId,
    required this.motivo,
    required this.retrasoEstimado,
  });

  factory ReportItem.fromJson(Map<String, dynamic> json) {
    return ReportItem(
      rutaId: (json['ruta_id'] ?? json['rutaId'] ?? json['ruta'] ?? '').toString(),
      motivo: (json['motivo'] ?? '').toString(),
      retrasoEstimado: (json['retrasoEstimado'] ?? json['retraso_estimado'] ?? json['retraso'] ?? 0) is num
          ? (json['retrasoEstimado'] ?? json['retraso_estimado'] ?? json['retraso'] as num).toInt()
          : int.tryParse((json['retrasoEstimado'] ?? json['retraso_estimado'] ?? json['retraso']).toString()) ?? 0,
    );
  }
}
