import 'package:flutter/material.dart';
import '../models/camera_model.dart';
import '../widgets/camera_status_card.dart';
import '../widgets/camera_warning_banner.dart';
import '../widgets/troubleshooting_section.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

class CameraDisconnectedView extends StatefulWidget {
  const CameraDisconnectedView({Key? key}) : super(key: key);

  @override
  State<CameraDisconnectedView> createState() => _CameraDisconnectedViewState();
}

class _CameraDisconnectedViewState extends State<CameraDisconnectedView> {
  final List<CameraModel> _cameras = [
    CameraModel(
      id: '1',
      name: 'Camera 1 - Front',
      macAddress: 'DC:54:XX:001',
      status: CameraStatus.disconnected,
    ),
    CameraModel(
      id: '2',
      name: 'Camera 2 - Cabin',
      macAddress: 'DC:54:XX:002',
      status: CameraStatus.connected,
      signalStrength: 85,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hasDisconnected = _cameras.any((c) => c.isDisconnected);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Camera Status',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 56,
                    color: Color(0xFFE53935),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.link_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Camera Disconnected',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We\'ve lost connection with one or more cameras',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _cameras
                    .map((camera) => CameraStatusCard(camera: camera))
                    .toList(),
              ),
            ),
            if (hasDisconnected)
              const CameraWarningBanner(
                message:
                    'SafeVision is operating with reduced monitoring capacity. Please reconnect Camera 1 as soon as possible for full protection.',
              ),
            const TroubleshootingSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Navegación
        },
      ),
    );
  }
}
