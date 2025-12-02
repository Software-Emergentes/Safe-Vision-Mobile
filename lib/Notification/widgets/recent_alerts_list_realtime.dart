// ==========================================
// lib/widgets/recent_alerts_list_realtime.dart
import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class RecentAlertsListRealtime extends StatelessWidget {
  final List<AlertModel> alerts;
  final int maxItems;

  const RecentAlertsListRealtime({
    Key? key,
    required this.alerts,
    this.maxItems = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayAlerts = alerts.take(maxItems).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alertas Recientes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (alerts.isNotEmpty)
                Text(
                  '${alerts.length} total',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (displayAlerts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No hay alertas recientes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            )
          else
            ...displayAlerts
                .map((alert) => AlertItemRealtime(alert: alert))
                .toList(),
        ],
      ),
    );
  }
}

class AlertItemRealtime extends StatelessWidget {
  final AlertModel alert;

  const AlertItemRealtime({
    Key? key,
    required this.alert,
  }) : super(key: key);

  Color get _iconColor {
    switch (alert.level) {
      case AlertLevel.low:
        return Colors.green;
      case AlertLevel.medium:
        return Colors.orange;
      case AlertLevel.high:
      case AlertLevel.critical:
        return Colors.red;
    }
  }

  IconData get _icon {
    if (alert.level == AlertLevel.low) {
      return Icons.check_circle;
    }
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: alert.isCritical
            ? Border.all(color: Colors.red.withOpacity(0.3), width: 2)
            : null,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              color: _iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.camera,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${alert.formattedTime} - ${alert.formattedDuration}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert.levelText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
