import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_endpoints.dart';

abstract class BaseService {
  final baseUrl = ApiEndpoints.apiV1Base;

  final storage = const FlutterSecureStorage();
}
