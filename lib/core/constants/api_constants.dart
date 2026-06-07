abstract final class ApiConstants {
  // Replace with your actual backend base URL
  static const String baseUrl = 'https://api.abky.com/api';

  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';
  static const String leads = '/leads/my';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String tokenKey = 'abky_auth_token';
  static const String userKey = 'abky_user_data';
}
