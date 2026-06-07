import '../constants/api_constants.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthService {
  AuthService._();
  static const AuthService instance = AuthService._();

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.instance.dio.post(
        ApiConstants.signIn,
        data: {'email': email.trim().toLowerCase(), 'password': password},
      );
      final authResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      await StorageService.instance.saveToken(authResponse.token);
      await StorageService.instance.saveUser(authResponse.user);
      return authResponse;
    } catch (e) {
      throw ApiService.extractErrorMessage(e);
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await ApiService.instance.dio.post(
        ApiConstants.signUp,
        data: {
          'email': email.trim().toLowerCase(),
          'password': password,
          if (name != null && name.isNotEmpty) 'name': name.trim(),
        },
      );
      final authResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      await StorageService.instance.saveToken(authResponse.token);
      await StorageService.instance.saveUser(authResponse.user);
      return authResponse;
    } catch (e) {
      throw ApiService.extractErrorMessage(e);
    }
  }

  Future<void> signOut() async {
    await StorageService.instance.clear();
  }

  Future<bool> isAuthenticated() async {
    final token = await StorageService.instance.getToken();
    return token != null && token.isNotEmpty;
  }
}
