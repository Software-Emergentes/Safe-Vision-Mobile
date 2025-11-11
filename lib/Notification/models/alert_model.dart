enum AlertLevel {
  low,
  medium,
  high,
  critical,
}

class AlertModel {
  final String id;
  final String tripId;
  final String type;
  final AlertLevel level;
  final DateTime timestamp;
  final Duration duration;
  final bool acknowledged;

  AlertModel({
    required this.id,
    required this.tripId,
    required this.type,
    required this.level,
    required this.timestamp,
    required this.duration,
    this.acknowledged = false,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      tripId: json['tripId'],
      type: json['type'],
      level: _parseAlertLevel(json['level']),
      timestamp: DateTime.parse(json['timestamp']),
      duration: Duration(seconds: json['durationSeconds']),
      acknowledged: json['acknowledged'] ?? false,
    );
  }

  static AlertLevel _parseAlertLevel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return AlertLevel.low;
      case 'medium':
        return AlertLevel.medium;
      case 'high':
        return AlertLevel.high;
      case 'critical':
        return AlertLevel.critical;
      default:
        return AlertLevel.low;
    }
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return 'Hoy, $hour:$minute';
  }

  String get formattedDuration {
    return 'Duración: ${duration.inMinutes} min';
  }
}
