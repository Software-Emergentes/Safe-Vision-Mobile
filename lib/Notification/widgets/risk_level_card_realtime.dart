// lib/widgets/risk_level_card_realtime.dart
import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class RiskLevelCardRealtime extends StatelessWidget {
  final AlertModel? currentAlert;
  final bool isConnected;

  const RiskLevelCardRealtime({
    Key? key,
    this.currentAlert,
    required this.isConnected,
  }) : super(key: key);

  Color get _backgroundColor {
    if (!isConnected) return Colors.grey[200]!;
    if (currentAlert == null) return const Color(0xFFE8F5E9);

    switch (currentAlert!.level) {
      case AlertLevel.low:
        return const Color(0xFFE8F5E9);
      case AlertLevel.medium:
        return const Color(0xFFFFF3E0);
      case AlertLevel.high:
      case AlertLevel.critical:
        return const Color(0xFFFFEBEE);
    }
  }

  Color get _badgeColor {
    if (!isConnected) return Colors.grey;
    if (currentAlert == null) return const Color(0xFF4CAF50);

    switch (currentAlert!.level) {
      case AlertLevel.low:
        return const Color(0xFF4CAF50);
      case AlertLevel.medium:
        return const Color(0xFFFF9800);
      case AlertLevel.high:
      case AlertLevel.critical:
        return const Color(0xFFE53935);
    }
  }

  String get _statusText {
    if (!isConnected) return 'DESCONECTADO';
    if (currentAlert == null) return 'NORMAL';
    return currentAlert!.levelText.toUpperCase();
  }

  String get _message {
    if (!isConnected) return 'Conectando al sistema de detección...';
    if (currentAlert == null) return 'El conductor está alerta y atento';
    return currentAlert!.description;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Nivel de Riesgo Actual',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isConnected)
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )
                        else
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _badgeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (currentAlert != null &&
                        currentAlert!.metrics != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (currentAlert!.metrics!['ear'] != null) ...[
                            Icon(Icons.remove_red_eye,
                                size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'EAR: ${currentAlert!.metrics!['ear'].toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (currentAlert!.metrics!['tilt'] != null) ...[
                            Icon(Icons.accessibility,
                                size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Incl: ${currentAlert!.metrics!['tilt'].toStringAsFixed(1)}°',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (currentAlert != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentAlert!.camera,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  currentAlert!.formattedDuration,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
