// lib/Home/views/home_view.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../widgets/current_trip_card.dart';
import '../models/trip_model.dart';
import '../../Monitoring/widgets/stats_card.dart';
import '../../Notification/widgets/risk_level_card_realtime.dart';
import '../../Notification/widgets/recent_alerts_list_realtime.dart';
import '../../Notification/models/alert_model.dart';
import '../../Notification/models/notification_model.dart';
import '../../Notification/services/alert_service.dart';
import '../../Notification/services/audio_alert_service.dart';
import 'trip_history_view.dart';
import '../../Monitoring/views/camera_connection_view.dart';
import '../../Monitoring/views/camera_disconnected_view.dart';
import '../../Notification/views/notifications_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  int _currentIndex = 0;

  // Servicios
  final AlertService _alertService = AlertService();
  final AudioAlertService _audioService = AudioAlertService();

  // Estado de alertas en tiempo real
  AlertModel? _currentAlert;
  List<AlertModel> _realtimeAlerts = [];
  bool _isConnected = false;
  bool _isDetectionRunning = false;
  bool _audioAlertsEnabled = true;
  int _unreadNotifications = 0;

  // Subscripciones a streams
  StreamSubscription<AlertModel>? _alertSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  StreamSubscription<NotificationModel>? _notificationSubscription;

  // Mock data del viaje actual
  final TripModel _currentTrip = TripModel(
    id: '1',
    driverId: 'driver_123',
    startTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
    status: 'active',
    drivingTime: const Duration(hours: 2, minutes: 35),
    recommendedRestTime: const Duration(hours: 1, minutes: 25),
    alertCount: 3,
  );

  // Estadísticas (se actualizarán con alertas reales)
  int _safeTrips = 8;
  int _weeklyAlerts = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _alertSubscription?.cancel();
    _connectionSubscription?.cancel();
    _notificationSubscription?.cancel();
    _audioService.stopAllSounds();
    _audioService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reconectar cuando la app vuelve al primer plano
      if (!_isConnected) {
        _alertService.connect();
      }
      _audioService.resume();
    } else if (state == AppLifecycleState.paused) {
      // Mantener alertas sonoras en background
      // NO detener audio, solo pausar visualización
    }
  }

  Future<void> _initializeServices() async {
    // Inicializar servicio de audio
    await _audioService.initialize();

    // Verificar estado del servidor
    final isServerOnline = await _alertService.checkServerHealth();

    if (!isServerOnline) {
      _showSnackBar(
        '⚠️ No se pudo conectar al sistema de detección',
        Colors.orange,
      );
      return;
    }

    // Conectar al WebSocket
    await _alertService.connect();

    // Suscribirse a alertas en tiempo real
    _alertSubscription = _alertService.alertStream.listen((alert) {
      setState(() {
        _currentAlert = alert;
        _realtimeAlerts = _alertService.alertHistory;

        // Actualizar contador de alertas semanales
        _weeklyAlerts = _realtimeAlerts
            .where((a) => DateTime.now().difference(a.timestamp).inDays < 7)
            .length;
      });

      // Reproducir alerta sonora según el nivel
      if (_audioAlertsEnabled) {
        _audioService.playAlert(alert.level);
      }

      // Mostrar alerta crítica con diálogo
      if (alert.level == AlertLevel.critical ||
          alert.level == AlertLevel.high) {
        _showCriticalAlertDialog(alert);
      }
    });

    // Suscribirse a estado de conexión
    _connectionSubscription =
        _alertService.connectionStream.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });

      if (isConnected) {
        _showSnackBar('✅ Sistema de detección conectado', Colors.green);
      } else {
        _showSnackBar('❌ Desconectado del sistema', Colors.red);
        _audioService.stopAllSounds();
      }
    });

    // Suscribirse a notificaciones
    _notificationSubscription =
        _alertService.notificationStream.listen((notification) {
      setState(() {
        _unreadNotifications++;
      });

      _showNotificationSnackBar(notification);
    });

    // Cargar historial inicial
    final history = await _alertService.getAlertHistory();
    setState(() {
      _realtimeAlerts = history;
      _weeklyAlerts = history
          .where((a) => DateTime.now().difference(a.timestamp).inDays < 7)
          .length;
    });
  }

  Future<void> _toggleDetection() async {
    if (_isDetectionRunning) {
      final success = await _alertService.stopDetection();
      if (success) {
        setState(() {
          _isDetectionRunning = false;
        });
        _audioService.stopAllSounds();
        _showSnackBar('⏸️ Detección detenida', Colors.orange);
      }
    } else {
      final success = await _alertService.startDetection();
      if (success) {
        setState(() {
          _isDetectionRunning = true;
        });
        _showSnackBar('▶️ Detección iniciada', Colors.green);
      }
    }
  }

  void _toggleAudioAlerts() {
    setState(() {
      _audioAlertsEnabled = !_audioAlertsEnabled;
    });

    _audioService.setEnabled(_audioAlertsEnabled);

    if (!_audioAlertsEnabled) {
      _audioService.stopAllSounds();
      _showSnackBar('🔇 Alertas sonoras desactivadas', Colors.grey);
    } else {
      _showSnackBar('🔊 Alertas sonoras activadas', Colors.green);
    }
  }

  void _showCriticalAlertDialog(AlertModel alert) {
    // Vibración y sonido de emergencia para alertas críticas
    if (alert.level == AlertLevel.critical) {
      _audioService.playEmergencySiren();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevenir cierre con botón atrás
        child: AlertDialog(
          backgroundColor: const Color(0xFFFFEBEE),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  alert.level == AlertLevel.critical
                      ? Icons.dangerous
                      : Icons.warning,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert.level == AlertLevel.critical
                      ? '🚨 ¡PELIGRO CRÍTICO!'
                      : '⚠️ ¡ALERTA ALTA!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.type,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                alert.description,
                style: const TextStyle(fontSize: 14),
              ),
              if (alert.level == AlertLevel.critical) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.red, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '¡DETENGA EL VEHÍCULO DE INMEDIATO!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.videocam, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alert.camera,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _audioService.stopAllSounds();
                Navigator.of(context).pop();
              },
              child: Text(
                alert.level == AlertLevel.critical
                    ? 'DETUVE EL VEHÍCULO'
                    : 'ENTENDIDO',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showNotificationSnackBar(NotificationModel notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(notification.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    notification.description,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: notification.iconColor,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'VER',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsView()),
            );
          },
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TripHistoryView(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _isConnected
              ? const CameraConnectionView()
              : const CameraDisconnectedView(),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        userName: 'Fabia Herrera',
        notificationCount: _unreadNotifications,
        onNotificationPressed: () async {
          setState(() {
            _unreadNotifications = 0;
          });
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsView(),
            ),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _alertService.getAlertHistory();
          setState(() {
            _realtimeAlerts = _alertService.alertHistory;
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Indicador de conexión del sistema
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isConnected
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isConnected ? Colors.green : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isConnected ? Icons.check_circle : Icons.sync,
                      color: _isConnected ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isConnected
                            ? 'Sistema de Detección Conectado'
                            : 'Reconectando al sistema...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isConnected ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                    // Toggle de audio
                    IconButton(
                      icon: Icon(
                        _audioAlertsEnabled
                            ? Icons.volume_up
                            : Icons.volume_off,
                        color: _audioAlertsEnabled ? Colors.green : Colors.grey,
                      ),
                      onPressed: _toggleAudioAlerts,
                      tooltip: _audioAlertsEnabled
                          ? 'Desactivar alertas sonoras'
                          : 'Activar alertas sonoras',
                    ),
                    if (!_isConnected)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Tarjeta del viaje actual
              CurrentTripCard(trip: _currentTrip),

              const SizedBox(height: 10),

              // Estadísticas actualizadas con datos reales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        icon: Icons.check_circle,
                        iconColor: const Color(0xFF4CAF50),
                        count: _safeTrips,
                        label: 'Viajes seguros',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        icon: Icons.warning,
                        iconColor: const Color(0xFFFFC107),
                        count: _weeklyAlerts,
                        label: 'Alertas esta semana',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Tarjeta de nivel de riesgo en tiempo real
              RiskLevelCardRealtime(
                currentAlert: _currentAlert,
                isConnected: _isConnected,
              ),

              const SizedBox(height: 16),

              // Control de detección
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: _isConnected ? _toggleDetection : null,
                  icon:
                      Icon(_isDetectionRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(
                    _isDetectionRunning
                        ? 'Detener Detección'
                        : 'Iniciar Detección',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isDetectionRunning
                        ? Colors.red
                        : const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lista de alertas recientes en tiempo real
              RecentAlertsListRealtime(
                alerts: _realtimeAlerts,
                maxItems: 5,
              ),

              const SizedBox(height: 16),

              // Botón para ver todas las alertas
              if (_realtimeAlerts.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsView(),
                        ),
                      );
                    },
                    child: const Text(
                      'Ver todas las alertas',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
