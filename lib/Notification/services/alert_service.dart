// lib/services/alert_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alert_model.dart';
import '../models/notification_model.dart';

class AlertService {
  static final AlertService _instance = AlertService._internal();
  factory AlertService() => _instance;
  AlertService._internal();

  // Configuración del servidor
  static const String SERVER_URL =
      'http://192.168.1.54:5000'; // Cambiar a IP del servidor

  IO.Socket? _socket;
  bool _isConnected = false;

  // Streams para alertas en tiempo real
  final _alertController = StreamController<AlertModel>.broadcast();
  final _notificationController =
      StreamController<NotificationModel>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<AlertModel> get alertStream => _alertController.stream;
  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _isConnected;

  // Historial de alertas
  final List<AlertModel> _alertHistory = [];
  final List<NotificationModel> _notificationHistory = [];

  List<AlertModel> get alertHistory => List.unmodifiable(_alertHistory);
  List<NotificationModel> get notificationHistory =>
      List.unmodifiable(_notificationHistory);

  /// Conectar al servidor WebSocket
  Future<void> connect() async {
    if (_isConnected) {
      print('✅ Ya está conectado al servidor');
      return;
    }

    try {
      _socket = IO.io(SERVER_URL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket!.connect();

      _socket!.on('connect', (_) {
        print('✅ Conectado al servidor de detección');
        _isConnected = true;
        _connectionController.add(true);

        // Solicitar última alerta al conectar
        _socket!.emit('request_latest_alert');
      });

      _socket!.on('disconnect', (_) {
        print('❌ Desconectado del servidor');
        _isConnected = false;
        _connectionController.add(false);
      });

      _socket!.on('connection_response', (data) {
        print('📡 Respuesta del servidor: ${data['message']}');
      });

      // Escuchar nuevas alertas
      _socket!.on('new_alert', (data) {
        _handleNewAlert(data);
      });

      _socket!.on('connect_error', (error) {
        print('❌ Error de conexión: $error');
        _isConnected = false;
        _connectionController.add(false);
      });
    } catch (e) {
      print('❌ Error al conectar: $e');
      _isConnected = false;
      _connectionController.add(false);
    }
  }

  /// Desconectar del servidor
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      _connectionController.add(false);
      print('🔌 Desconectado del servidor');
    }
  }

  /// Manejar nueva alerta recibida
  void _handleNewAlert(dynamic data) {
    try {
      print('📥 Nueva alerta recibida: ${data['state']}');

      // Crear modelo de alerta
      final alert = _createAlertFromData(data);
      _alertHistory.insert(0, alert);

      // Limitar historial a 50 alertas
      if (_alertHistory.length > 50) {
        _alertHistory.removeLast();
      }

      // Emitir alerta
      _alertController.add(alert);

      // Si es alerta crítica o alta, crear notificación
      if (alert.level == AlertLevel.high ||
          alert.level == AlertLevel.critical) {
        final notification = _createNotificationFromAlert(alert);
        _notificationHistory.insert(0, notification);

        if (_notificationHistory.length > 50) {
          _notificationHistory.removeLast();
        }

        _notificationController.add(notification);
      }
    } catch (e) {
      print('❌ Error al procesar alerta: $e');
    }
  }

  /// Crear AlertModel desde datos del servidor
  AlertModel _createAlertFromData(dynamic data) {
    AlertLevel level;
    switch (data['level']) {
      case 'low':
        level = AlertLevel.low;
        break;
      case 'medium':
        level = AlertLevel.medium;
        break;
      case 'high':
        level = AlertLevel.high;
        break;
      default:
        level = AlertLevel.low;
    }

    return AlertModel(
      id: data['id'] ?? 'alert_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.parse(data['timestamp']),
      type: data['type'] ?? 'Alerta',
      level: level,
      camera: data['camera'] ?? 'Cámara',
      description: data['message'] ?? '',
      metrics: {
        if (data['metrics'] != null) ...{
          'ear': data['metrics']['ear'],
          'tilt': data['metrics']['tilt'],
        }
      },
    );
  }

  /// Crear NotificationModel desde AlertModel
  NotificationModel _createNotificationFromAlert(AlertModel alert) {
    NotificationType notifType;
    if (alert.level == AlertLevel.critical || alert.level == AlertLevel.high) {
      notifType = NotificationType.critical;
    } else if (alert.level == AlertLevel.medium) {
      notifType = NotificationType.warning;
    } else {
      notifType = NotificationType.info;
    }

    return NotificationModel(
      id: alert.id,
      title: alert.type,
      description: '${alert.description} - ${alert.camera}',
      timestamp: alert.timestamp,
      type: notifType,
      isNew: true,
      isRead: false,
    );
  }

  /// Obtener última alerta via HTTP
  Future<AlertModel?> getLatestAlert() async {
    try {
      final response =
          await http.get(Uri.parse('$SERVER_URL/api/alerts/latest'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _createAlertFromData(data);
      }
      return null;
    } catch (e) {
      print('❌ Error al obtener última alerta: $e');
      return null;
    }
  }

  /// Obtener historial de alertas via HTTP
  Future<List<AlertModel>> getAlertHistory() async {
    try {
      final response =
          await http.get(Uri.parse('$SERVER_URL/api/alerts/history'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final alerts = (data['alerts'] as List)
            .map((alertData) => _createAlertFromData(alertData))
            .toList();

        _alertHistory.clear();
        _alertHistory.addAll(alerts);

        return alerts;
      }
      return [];
    } catch (e) {
      print('❌ Error al obtener historial: $e');
      return [];
    }
  }

  /// Iniciar sistema de detección
  Future<bool> startDetection() async {
    try {
      final response = await http.post(Uri.parse('$SERVER_URL/api/start'));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error al iniciar detección: $e');
      return false;
    }
  }

  /// Detener sistema de detección
  Future<bool> stopDetection() async {
    try {
      final response = await http.post(Uri.parse('$SERVER_URL/api/stop'));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error al detener detección: $e');
      return false;
    }
  }

  /// Verificar estado del servidor
  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$SERVER_URL/api/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Limpiar historial
  void clearHistory() {
    _alertHistory.clear();
    _notificationHistory.clear();
  }

  /// Liberar recursos
  void dispose() {
    disconnect();
    _alertController.close();
    _notificationController.close();
    _connectionController.close();
  }
}
