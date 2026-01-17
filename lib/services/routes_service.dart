import 'package:dio/dio.dart';
import 'api_client.dart';

class RoutesService {
  static Future<List<dynamic>> listarRutas() async {
    try {
      final res = await ApiClient.dio.get('/route');

      // Si el backend devuelve lista directa: [...]
      if (res.data is List) return res.data as List;

      // Si devuelve objeto: { data: [...] }
      if (res.data is Map && (res.data['data'] is List)) {
        return res.data['data'] as List;
      }

      throw Exception('Formato de respuesta inesperado');
    } on DioException catch (e) {
      throw Exception(e.response?.data?.toString() ?? 'Error listando rutas');
    }
  }

  static Future<Map<String, dynamic>> obtenerRuta(String userId) async {
    // Nota: en tu ejemplo es /route/user/<id>
    // Aunque se llame "user", parece devolver una ruta con paradas.
    try {
      final res = await ApiClient.dio.get('/route/user/$userId');

      if (res.data is Map<String, dynamic>) return res.data as Map<String, dynamic>;
      if (res.data is Map) return Map<String, dynamic>.from(res.data);

      throw Exception('Formato de respuesta inesperado');
    } on DioException catch (e) {
      throw Exception(e.response?.data?.toString() ?? 'Error obteniendo ruta');
    }
  }
}
