// lib/models/alert_model.dart
import 'package:intl/intl.dart';

enum AlertLevel {
  low,
  medium,
  high,
  critical,
}

class AlertModel {
  final String id;
  final DateTime timestamp;
  final String type;
  final AlertLevel level;
  final String camera;
  final String description;
  final Map<String, dynamic>? metrics;

  AlertModel({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.level,
    required this.camera,
    required this.description,
    this.metrics,
  });

  String get formattedTime {
    return DateFormat('HH:mm:ss').format(timestamp);
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }

  String get formattedDuration {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Hace ${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inDays}d';
    }
  }

  String get levelText {
    switch (level) {
      case AlertLevel.low:
        return 'Bajo';
      case AlertLevel.medium:
        return 'Medio';
      case AlertLevel.high:
        return 'Alto';
      case AlertLevel.critical:
        return 'Crítico';
    }
  }

  bool get isCritical =>
      level == AlertLevel.critical || level == AlertLevel.high;

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    AlertLevel parseLevel(String levelStr) {
      switch (levelStr.toLowerCase()) {
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

    return AlertModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      level: parseLevel(json['level']),
      camera: json['camera'],
      description: json['message'] ?? json['description'] ?? '',
      metrics: json['metrics'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'level': level.toString().split('.').last,
      'camera': camera,
      'description': description,
      'metrics': metrics,
    };
  }

  AlertModel copyWith({
    String? id,
    DateTime? timestamp,
    String? type,
    AlertLevel? level,
    String? camera,
    String? description,
    Map<String, dynamic>? metrics,
  }) {
    return AlertModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      level: level ?? this.level,
      camera: camera ?? this.camera,
      description: description ?? this.description,
      metrics: metrics ?? this.metrics,
    );
  }
}
