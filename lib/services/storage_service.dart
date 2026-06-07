import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../constants/api_constants.dart';
import '../models/auth_response.dart';

class StorageService {
  StorageService._();

  static const StorageService instance = StorageService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: ApiConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: ApiConstants.tokenKey);
  }

  Future<void> saveUser(AuthUser user) async {
    await _storage.write(
      key: ApiConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<AuthUser?> getUser() async {
    final raw = await _storage.read(key: ApiConstants.userKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return AuthUser.fromJson(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
