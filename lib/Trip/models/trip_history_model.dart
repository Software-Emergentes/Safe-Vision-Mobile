import 'package:flutter/material.dart';

enum TripStatus {
  safe,
  moderate,
  high,
}

class TripHistoryModel {
  final String id;
  final String origin;
  final String destination;
  final DateTime date;
  final Duration duration;
  final double distance;
  final int alertCount;
  final TripStatus status;

  TripHistoryModel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.date,
    required this.duration,
    required this.distance,
    required this.alertCount,
    required this.status,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripHistoryModel(
      id: json['id'],
      origin: json['origin'],
      destination: json['destination'],
      date: DateTime.parse(json['date']),
      duration: Duration(minutes: json['durationMinutes']),
      distance: json['distanceKm'].toDouble(),
      alertCount: json['alertCount'],
      status: _parseStatus(json['status']),
    );
  }

  static TripStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return TripStatus.safe;
      case 'moderate':
        return TripStatus.moderate;
      case 'high':
        return TripStatus.high;
      default:
        return TripStatus.safe;
    }
  }

  String get formattedDate {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String get formattedDistance {
    return '${distance.toStringAsFixed(0)} km';
  }

  String get statusLabel {
    switch (status) {
      case TripStatus.safe:
        return 'Seguro';
      case TripStatus.moderate:
        return 'Moderado';
      case TripStatus.high:
        return 'Alto';
    }
  }

  Color get statusColor {
    switch (status) {
      case TripStatus.safe:
        return const Color(0xFF4CAF50);
      case TripStatus.moderate:
        return const Color(0xFFFFC107);
      case TripStatus.high:
        return const Color(0xFFE53935);
    }
  }
}
