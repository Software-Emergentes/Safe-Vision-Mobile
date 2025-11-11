import 'package:flutter/material.dart';
import '../models/camera_model.dart';

class CameraStatusCard extends StatelessWidget {
  final CameraModel camera;
  final VoidCallback? onTap;

  const CameraStatusCard({
    Key? key,
    required this.camera,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              camera.isConnected ? const Color(0xFF4CAF50) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: camera.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: camera.statusColor,
                        size: 24,
                      ),
                      if (camera.isDisconnected)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.link_off,
                              color: Color(0xFFE53935),
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              camera.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (camera.isDisconnected)
                            const Icon(
                              Icons.warning,
                              color: Color(0xFFE53935),
                              size: 20,
                            ),
                          if (camera.isConnected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF4CAF50),
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        camera.macAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (camera.isConnected) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.wifi,
                              size: 14,
                              color: camera.statusColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: (camera.signalStrength ?? 0) / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  camera.statusColor,
                                ),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              camera.statusLabel,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (camera.signalLabel.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                camera.signalLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Status: Active',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                      if (camera.isConnecting) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.wifi,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.grey,
                                ),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              camera.statusLabel,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '⚬ Searching for device...',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '⚬ Establishing connection...',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      if (camera.isDisconnected) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.link_off,
                              size: 14,
                              color: camera.statusColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              camera.statusLabel,
                              style: TextStyle(
                                fontSize: 12,
                                color: camera.statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (camera.isConnected) {
      return const Color(0xFFE8F5E9);
    } else if (camera.isDisconnected) {
      return const Color(0xFFFFEBEE);
    }
    return Colors.grey[100]!;
  }
}
