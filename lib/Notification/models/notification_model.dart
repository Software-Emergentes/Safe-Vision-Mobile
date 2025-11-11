import 'package:flutter/material.dart';

enum NotificationType {
  critical,
  warning,
  info,
  success,
}

enum NotificationCategory {
  all,
  critical,
  updates,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final bool isNew;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.isNew = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      type: _parseType(json['type']),
      isRead: json['isRead'] ?? false,
      isNew: json['isNew'] ?? false,
    );
  }

  static NotificationType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'critical':
        return NotificationType.critical;
      case 'warning':
        return NotificationType.warning;
      case 'info':
        return NotificationType.info;
      case 'success':
        return NotificationType.success;
      default:
        return NotificationType.info;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${_formatTime(timestamp)}';
    } else {
      return 'Yesterday, ${_formatTime(timestamp)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.critical:
        return const Color(0xFFE53935);
      case NotificationType.warning:
        return const Color(0xFFFFC107);
      case NotificationType.info:
        return const Color(0xFF2196F3);
      case NotificationType.success:
        return const Color(0xFF4CAF50);
    }
  }

  Color get backgroundColor {
    switch (type) {
      case NotificationType.critical:
        return const Color(0xFFFFEBEE);
      case NotificationType.warning:
        return const Color(0xFFFFF9C4);
      case NotificationType.info:
        return const Color(0xFFE3F2FD);
      case NotificationType.success:
        return const Color(0xFFE8F5E9);
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.critical:
        return Icons.warning;
      case NotificationType.warning:
        return Icons.warning_amber;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.success:
        return Icons.check_circle;
    }
  }

  bool get isCritical => type == NotificationType.critical;
}
