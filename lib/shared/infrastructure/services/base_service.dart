import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseService {
  final baseUrl = 'http://192.168.1.54:8000/api/v1';

  final storage = const FlutterSecureStorage();
}
