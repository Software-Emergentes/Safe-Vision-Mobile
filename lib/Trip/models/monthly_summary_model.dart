class MonthlySummaryModel {
  final int totalTrips;
  final Duration totalDrivingTime;
  final int safeTrips;
  final int totalAlerts;

  MonthlySummaryModel({
    required this.totalTrips,
    required this.totalDrivingTime,
    required this.safeTrips,
    required this.totalAlerts,
  });

  factory MonthlySummaryModel.fromJson(Map<String, dynamic> json) {
    return MonthlySummaryModel(
      totalTrips: json['totalTrips'],
      totalDrivingTime: Duration(hours: json['totalDrivingHours']),
      safeTrips: json['safeTrips'],
      totalAlerts: json['totalAlerts'],
    );
  }

  String get formattedDrivingTime {
    return '${totalDrivingTime.inHours}h';
  }
}
