import 'package:flutter/material.dart';
import '../models/trip_history_model.dart';
import '../models/monthly_summary_model.dart';
import '../widgets/trip_history_card.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/filter_chip_bar.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

class TripHistoryView extends StatefulWidget {
  const TripHistoryView({Key? key}) : super(key: key);

  @override
  State<TripHistoryView> createState() => _TripHistoryViewState();
}

class _TripHistoryViewState extends State<TripHistoryView> {
  int _selectedFilterIndex = 0;

  // Mock data
  final List<TripHistoryModel> _trips = [
    TripHistoryModel(
      id: '1',
      origin: 'Lima',
      destination: 'Trujillo',
      date: DateTime(2025, 11, 4),
      duration: const Duration(hours: 8, minutes: 25),
      distance: 558,
      alertCount: 0,
      status: TripStatus.safe,
    ),
    TripHistoryModel(
      id: '2',
      origin: 'Trujillo',
      destination: 'Chiclayo',
      date: DateTime(2025, 11, 2),
      duration: const Duration(hours: 3, minutes: 15),
      distance: 210,
      alertCount: 2,
      status: TripStatus.moderate,
    ),
    TripHistoryModel(
      id: '3',
      origin: 'Chiclayo',
      destination: 'Piura',
      date: DateTime(2025, 11, 2),
      duration: const Duration(hours: 4, minutes: 50),
      distance: 285,
      alertCount: 5,
      status: TripStatus.high,
    ),
  ];

  final MonthlySummaryModel _monthlySummary = MonthlySummaryModel(
    totalTrips: 24,
    totalDrivingTime: const Duration(hours: 156),
    safeTrips: 18,
    totalAlerts: 12,
  );

  @override
  Widget build(BuildContext context) {
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
          'Historial de Viajes',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          FilterChipBar(
            selectedIndex: _selectedFilterIndex,
            onSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ..._trips
                    .map((trip) => TripHistoryCard(
                          trip: trip,
                          onTap: () {
                            // Navegar a detalle del viaje
                          },
                        ))
                    .toList(),
                const SizedBox(height: 10),
                MonthlySummaryCard(summary: _monthlySummary),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Navegación
        },
      ),
    );
  }
}
