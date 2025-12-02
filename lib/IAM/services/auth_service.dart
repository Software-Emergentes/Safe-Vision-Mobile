import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/infrastructure/services/base_service.dart';
import '../../shared/infrastructure/config/api_endpoints.dart';

class AuthService extends BaseService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Verificar conexión con el backend
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.apiV1Base}/authentication/sign-in'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      // Si responde (incluso con error 400/401), significa que está conectado
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      print('❌ Error de conexión: $e');
      return false;
    }
  }

  /// Sign In - Iniciar sesión
  Future<Map<String, dynamic>?> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.signIn),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 Sign In Response Status: ${response.statusCode}');
      print('📡 Sign In Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('❌ Error en sign in: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error de conexión en sign in: $e');
      return null;
    }
  }

  /// Sign Up - Registro de usuario
  Future<Map<String, dynamic>?> signUp(String username, String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.signUp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
          'email': email,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 Sign Up Response Status: ${response.statusCode}');
      print('📡 Sign Up Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('❌ Error en sign up: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error de conexión en sign up: $e');
      return null;
    }
  }

  /// Verificar código MFA
  Future<Map<String, dynamic>?> verifyMfa(int userId, String mfaCode) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.verifyMfa),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'mfaCode': mfaCode,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('❌ Error en verify MFA: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error de conexión en verify MFA: $e');
      return null;
    }
  }
}

