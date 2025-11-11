import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../widgets/notification_item.dart';
import '../widgets/notification_filter_tabs.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  final List<NotificationModel> _allNotifications = [
    NotificationModel(
      id: '1',
      title: 'Critical Alert Detected',
      description:
          'Micro-sleep detected on Camera 1. Driver Carlos Mendoza needs immediate attention.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.critical,
      isNew: true,
    ),
    NotificationModel(
      id: '2',
      title: 'Trip Completed Successfully',
      description:
          'Juan Pérez completed Lima → Trujillo with 0 critical alerts.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.success,
    ),
    NotificationModel(
      id: '3',
      title: 'Rest Break Reminder',
      description:
          'Maria Torres has been driving for 3h 45m. Recommend a rest break soon.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.info,
    ),
    NotificationModel(
      id: '4',
      title: 'Moderate Alert',
      description:
          'Prolonged blinking detected. Driver was advised to take a break.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.warning,
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: 'System Update Available',
      description:
          'SafeVision v2.4 is now available with improved AI detection.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 15)),
      type: NotificationType.info,
      isRead: true,
    ),
    NotificationModel(
      id: '6',
      title: 'Cameras Connected',
      description: 'Both cameras (Front & Cabin) are now connected and ready.',
      timestamp: DateTime.now()
          .subtract(const Duration(days: 1, hours: 17, minutes: 45)),
      type: NotificationType.success,
      isRead: true,
    ),
  ];

  List<NotificationModel> get _filteredNotifications {
    switch (_selectedCategory) {
      case NotificationCategory.all:
        return _allNotifications;
      case NotificationCategory.critical:
        return _allNotifications
            .where((n) =>
                n.type == NotificationType.critical ||
                n.type == NotificationType.warning)
            .toList();
      case NotificationCategory.updates:
        return _allNotifications
            .where((n) =>
                n.type == NotificationType.info ||
                n.type == NotificationType.success)
            .toList();
    }
  }

  Map<String, List<NotificationModel>> get _groupedNotifications {
    final Map<String, List<NotificationModel>> grouped = {
      'Today': [],
      'Yesterday': [],
    };

    for (var notification in _filteredNotifications) {
      final now = DateTime.now();
      final difference = now.difference(notification.timestamp);

      if (difference.inHours < 24) {
        grouped['Today']!.add(notification);
      } else {
        grouped['Yesterday']!.add(notification);
      }
    }

    return grouped;
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        // En producción, aquí llamarías al service para marcar como leídas
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          NotificationFilterTabs(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (grouped['Today']!.isNotEmpty) ...[
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...grouped['Today']!.map((notification) => NotificationItem(
                        notification: notification,
                        onTap: () {
                          // Marcar como leída o navegar a detalle
                        },
                      )),
                  const SizedBox(height: 20),
                ],
                if (grouped['Yesterday']!.isNotEmpty) ...[
                  Text(
                    'Yesterday',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...grouped['Yesterday']!
                      .map((notification) => NotificationItem(
                            notification: notification,
                            onTap: () {
                              // Marcar como leída o navegar a detalle
                            },
                          )),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
