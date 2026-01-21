import 'package:dio/dio.dart';

class ErrorMapper {
  static String toUserMessage(dynamic e) {
    if (e is DioException) {
      // DNS / host lookup
      final msg = (e.message ?? '').toLowerCase();
      if (msg.contains('failed host lookup')) {
        return 'No se pudo resolver el servidor (DNS). Cambia de red o prueba con datos móviles.';
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return 'El servidor tardó demasiado (timeout). Intenta de nuevo.';
      }

      if (e.type == DioExceptionType.connectionError) {
        return 'Sin conexión al servidor. Revisa tu internet.';
      }

      final code = e.response?.statusCode;
      if (code != null) {
        if (code == 401) return 'Credenciales incorrectas.';
        if (code == 403) return 'Acceso denegado al servicio.';
        if (code == 404) return 'Servicio no encontrado (URL incorrecta).';
        if (code >= 500) return 'Servidor con problemas. Intenta en unos minutos.';
        return 'Error HTTP $code.';
      }
    }

    return 'Ocurrió un error inesperado. Intenta de nuevo.';
  }
}
