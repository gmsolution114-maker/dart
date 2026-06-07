import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  late final Dio _dio = _buildDio();

  Dio get dio => _dio;

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.instance.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static String extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final msg = data['error'] ?? data['message'] ?? data['msg'];
        if (msg != null) return msg.toString();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Request timed out. Check your connection and try again.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'Cannot connect to server. Check your internet connection.';
      }
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) return 'Session expired. Please sign in again.';
      if (statusCode == 403) return 'Access denied.';
      if (statusCode == 404) return 'Resource not found.';
      if (statusCode != null && statusCode >= 500) return 'Server error. Please try again later.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
