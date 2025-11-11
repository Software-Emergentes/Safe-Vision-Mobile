import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class RecentAlertsList extends StatelessWidget {
  final List<AlertModel> alerts;

  const RecentAlertsList({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alertas Recientes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...alerts.map((alert) => AlertItem(alert: alert)).toList(),
        ],
      ),
    );
  }
}

class AlertItem extends StatelessWidget {
  final AlertModel alert;

  const AlertItem({
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
    return alert.type == 'Descanso completado'
        ? Icons.check_circle
        : Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                  '${alert.formattedTime} - ${alert.formattedDuration}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
