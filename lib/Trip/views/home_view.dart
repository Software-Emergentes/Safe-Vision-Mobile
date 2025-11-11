import 'package:flutter/material.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../widgets/current_trip_card.dart';
import '../models/trip_model.dart';
import '../../Monitoring/widgets/stats_card.dart';
import '../../Notification/widgets/risk_level_card.dart';
import '../../Notification/widgets/recent_alerts_list.dart';
import '../../Notification/models/alert_model.dart';
import 'trip_history_view.dart';
import '../../Monitoring/views/camera_connection_view.dart';
import '../../Monitoring/views/camera_disconnected_view.dart';
import '../../Notification/views/notifications_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  // Mock data - En producción vendrían de los services
  final TripModel _currentTrip = TripModel(
    id: '1',
    driverId: 'driver_123',
    startTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
    status: 'active',
    drivingTime: const Duration(hours: 2, minutes: 35),
    recommendedRestTime: const Duration(hours: 1, minutes: 25),
    alertCount: 3,
  );

  final List<AlertModel> _recentAlerts = [
    AlertModel(
      id: '1',
      tripId: '1',
      type: 'Parpadeo prolongado detectado',
      level: AlertLevel.medium,
      timestamp: DateTime.now().subtract(const Duration(minutes: 37)),
      duration: const Duration(minutes: 0),
    ),
    AlertModel(
      id: '2',
      tripId: '1',
      type: 'Descanso completado',
      level: AlertLevel.low,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      duration: const Duration(minutes: 20),
    ),
  ];

  void _onBottomNavTap(int index) {
    if (index == 1) {
      // Navegar a Historial
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TripHistoryView(),
        ),
      );
    } else if (index == 2) {
      // Navegar a Cámara (puedes elegir cuál vista mostrar)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraConnectionView(),
          // O usa: const CameraDisconnectedView()
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
      // 0: Home (ya estamos aquí)
      // 3: Perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        userName: 'Fabia Herrera',
        notificationCount: 9,
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsView(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CurrentTripCard(trip: _currentTrip),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      icon: Icons.check_circle,
                      iconColor: const Color(0xFF4CAF50),
                      count: 8,
                      label: 'Viajes seguros',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      icon: Icons.warning,
                      iconColor: const Color(0xFFFFC107),
                      count: 3,
                      label: 'Alertas esta semana',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const RiskLevelCard(
              level: 'Bajo',
              message: 'Excelente. Continúa manejando con precaución.',
            ),
            const SizedBox(height: 20),
            RecentAlertsList(alerts: _recentAlerts),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}