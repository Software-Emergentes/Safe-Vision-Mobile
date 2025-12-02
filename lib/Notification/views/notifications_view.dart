// lib/Notification/views/notifications_view.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/notification_model.dart';
import '../models/alert_model.dart';
import '../widgets/notification_item.dart';
import '../widgets/notification_filter_tabs.dart';
import '../services/alert_service.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  final AlertService _alertService = AlertService();

  List<NotificationModel> _realtimeNotifications = [];
  List<NotificationModel> _staticNotifications = [];

  StreamSubscription<NotificationModel>? _notificationSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    // Cargar notificaciones estáticas (mock)
    _staticNotifications = [
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
        description:
            'Both cameras (Front & Cabin) are now connected and ready.',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1, hours: 17, minutes: 45)),
        type: NotificationType.success,
        isRead: true,
      ),
    ];

    // Cargar notificaciones del servicio de alertas
    _realtimeNotifications = _alertService.notificationHistory;

    // Suscribirse a nuevas notificaciones
    _notificationSubscription =
        _alertService.notificationStream.listen((notification) {
      setState(() {
        _realtimeNotifications.insert(0, notification);
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  List<NotificationModel> get _allNotifications {
    // Combinar notificaciones en tiempo real con estáticas
    final all = [..._realtimeNotifications, ..._staticNotifications];
    // Ordenar por timestamp descendente
    all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return all;
  }

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
      'Earlier': [],
    };

    for (var notification in _filteredNotifications) {
      final now = DateTime.now();
      final difference = now.difference(notification.timestamp);

      if (difference.inHours < 24) {
        grouped['Today']!.add(notification);
      } else if (difference.inDays < 2) {
        grouped['Yesterday']!.add(notification);
      } else {
        grouped['Earlier']!.add(notification);
      }
    }

    return grouped;
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _realtimeNotifications) {
        notification.isRead = true;
        notification.isNew = false;
      }
      for (var notification in _staticNotifications) {
        notification.isRead = true;
        notification.isNew = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markAsRead(NotificationModel notification) {
    setState(() {
      notification.isRead = true;
      notification.isNew = false;
    });
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _realtimeNotifications.clear();
                _staticNotifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedNotifications;
    final unreadCount = _allNotifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              if (value == 'mark_all') {
                _markAllAsRead();
              } else if (value == 'clear_all') {
                _clearAllNotifications();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20),
                    SizedBox(width: 12),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20, color: Color(0xFFE53935)),
                    SizedBox(width: 12),
                    Text(
                      'Clear all',
                      style: TextStyle(color: Color(0xFFE53935)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                  child: _filteredNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No notifications',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You\'re all caught up!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _initializeNotifications();
                          },
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: [
                              if (grouped['Today']!.isNotEmpty) ...[
                                _buildSectionHeader(
                                    'Today', grouped['Today']!.length),
                                const SizedBox(height: 12),
                                ...grouped['Today']!.map(
                                  (notification) => NotificationItem(
                                    notification: notification,
                                    onTap: () {
                                      _markAsRead(notification);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (grouped['Yesterday']!.isNotEmpty) ...[
                                _buildSectionHeader(
                                    'Yesterday', grouped['Yesterday']!.length),
                                const SizedBox(height: 12),
                                ...grouped['Yesterday']!.map(
                                  (notification) => NotificationItem(
                                    notification: notification,
                                    onTap: () {
                                      _markAsRead(notification);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (grouped['Earlier']!.isNotEmpty) ...[
                                _buildSectionHeader(
                                    'Earlier', grouped['Earlier']!.length),
                                const SizedBox(height: 12),
                                ...grouped['Earlier']!.map(
                                  (notification) => NotificationItem(
                                    notification: notification,
                                    onTap: () {
                                      _markAsRead(notification);
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
