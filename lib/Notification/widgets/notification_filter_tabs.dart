import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationFilterTabs extends StatelessWidget {
  final NotificationCategory selectedCategory;
  final Function(NotificationCategory) onCategoryChanged;

  const NotificationFilterTabs({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _FilterTab(
            label: 'All',
            isSelected: selectedCategory == NotificationCategory.all,
            onTap: () => onCategoryChanged(NotificationCategory.all),
          ),
          const SizedBox(width: 16),
          _FilterTab(
            label: 'Critical',
            isSelected: selectedCategory == NotificationCategory.critical,
            onTap: () => onCategoryChanged(NotificationCategory.critical),
          ),
          const SizedBox(width: 16),
          _FilterTab(
            label: 'Updates',
            isSelected: selectedCategory == NotificationCategory.updates,
            onTap: () => onCategoryChanged(NotificationCategory.updates),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFFE53935) : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE53935) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
