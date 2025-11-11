import 'package:flutter/material.dart';
import '../models/camera_model.dart';
import '../widgets/camera_status_card.dart';
import '../widgets/connection_tips_section.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

class CameraConnectionView extends StatefulWidget {
  const CameraConnectionView({Key? key}) : super(key: key);

  @override
  State<CameraConnectionView> createState() => _CameraConnectionViewState();
}

class _CameraConnectionViewState extends State<CameraConnectionView> {
  final List<CameraModel> _cameras = [
    CameraModel(
      id: '1',
      name: 'Camera 1 - Front',
      macAddress: 'DC:54:XX:001',
      status: CameraStatus.connected,
      signalStrength: 88,
    ),
    CameraModel(
      id: '2',
      name: 'Camera 2 - Cabin',
      macAddress: 'DC:54:XX:002',
      status: CameraStatus.connecting,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          'Camera Connection',
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
            const SizedBox(height: 30),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'S',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  TextSpan(
                    text: 'afeVision',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Connect your cameras',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Ensure both cameras are powered on\nand ready to connect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _cameras
                    .map((camera) => CameraStatusCard(camera: camera))
                    .toList(),
              ),
            ),
            const ConnectionTipsSection(),
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
