class TripModel {
  final String id;
  final String driverId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final Duration drivingTime;
  final Duration recommendedRestTime;
  final int alertCount;

  TripModel({
    required this.id,
    required this.driverId,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.drivingTime,
    required this.recommendedRestTime,
    this.alertCount = 0,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      driverId: json['driverId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: json['status'],
      drivingTime: Duration(minutes: json['drivingTimeMinutes']),
      recommendedRestTime:
          Duration(minutes: json['recommendedRestTimeMinutes']),
      alertCount: json['alertCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status,
      'drivingTimeMinutes': drivingTime.inMinutes,
      'recommendedRestTimeMinutes': recommendedRestTime.inMinutes,
      'alertCount': alertCount,
    };
  }

  String get formattedDrivingTime {
    final hours = drivingTime.inHours;
    final minutes = drivingTime.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  double get progress {
    final totalMinutes = drivingTime.inMinutes + recommendedRestTime.inMinutes;
    return totalMinutes > 0 ? drivingTime.inMinutes / totalMinutes : 0.0;
  }
}
