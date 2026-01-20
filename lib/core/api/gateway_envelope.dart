import 'dart:convert';

class GatewayEnvelope {
  /// Para casos como registro/login donde request debe ser JSON serializado como string
  static Map<String, dynamic> buildJson({
    required String endpointId,
    required Map<String, dynamic> requestObj,
  }) {
    return {
      'endpoint_id': endpointId,
      'request': jsonEncode(requestObj),
    };
  }

  /// Para casos como:
  /// - listar rutas: request = ""
  /// - obtener ruta: request = "<id>"
  static Map<String, dynamic> buildRaw({
    required String endpointId,
    required String requestRaw,
  }) {
    return {
      'endpoint_id': endpointId,
      'request': requestRaw,
    };
  }
}
