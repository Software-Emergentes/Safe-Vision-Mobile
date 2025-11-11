import 'package:flutter/material.dart';
import '../models/monthly_summary_model.dart';

class MonthlySummaryCard extends StatelessWidget {
  final MonthlySummaryModel summary;

  const MonthlySummaryCard({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen del Mes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  value: summary.totalTrips.toString(),
                  label: 'Viajes totales',
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  value: summary.formattedDrivingTime,
                  label: 'Tiempo de conducción',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  value: summary.safeTrips.toString(),
                  label: 'Viajes seguros',
                  color: const Color(0xFF4CAF50),
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  value: summary.totalAlerts.toString(),
                  label: 'Alertas totales',
                  color: const Color(0xFFFFC107),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
