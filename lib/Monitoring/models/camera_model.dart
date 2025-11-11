import 'package:flutter/material.dart';

enum CameraStatus {
  connected,
  disconnected,
  connecting,
}

class CameraModel {
  final String id;
  final String name;
  final String macAddress;
  final CameraStatus status;
  final int? signalStrength;
  final String? connectionMessage;

  CameraModel({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.status,
    this.signalStrength,
    this.connectionMessage,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'],
      name: json['name'],
      macAddress: json['macAddress'],
      status: _parseStatus(json['status']),
      signalStrength: json['signalStrength'],
      connectionMessage: json['connectionMessage'],
    );
  }

  static CameraStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return CameraStatus.connected;
      case 'connecting':
        return CameraStatus.connecting;
      case 'disconnected':
      default:
        return CameraStatus.disconnected;
    }
  }

  String get statusLabel {
    switch (status) {
      case CameraStatus.connected:
        return 'Connected';
      case CameraStatus.connecting:
        return 'Connecting...';
      case CameraStatus.disconnected:
        return 'Disconnected';
    }
  }

  String get signalLabel {
    if (signalStrength == null) return '';
    if (signalStrength! >= 80) return 'Signal: Strong (${signalStrength}%)';
    if (signalStrength! >= 50) return 'Signal: Medium (${signalStrength}%)';
    return 'Signal: Weak (${signalStrength}%)';
  }

  Color get statusColor {
    switch (status) {
      case CameraStatus.connected:
        return const Color(0xFF4CAF50);
      case CameraStatus.connecting:
        return const Color(0xFFFFC107);
      case CameraStatus.disconnected:
        return const Color(0xFFE53935);
    }
  }

  bool get isConnected => status == CameraStatus.connected;
  bool get isDisconnected => status == CameraStatus.disconnected;
  bool get isConnecting => status == CameraStatus.connecting;
}
