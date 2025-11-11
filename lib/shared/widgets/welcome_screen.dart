import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top image (rounded)
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.asset(
                      'assets/images/drive.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Logo + subtitle + button
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo text (replica estilizada)
                    Text(
                      'SafeVision',
                      style: TextStyle(
                        color: const Color(0xFFD81B60), // rojo/rosa similar
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enhance your fleet\'s safety and upgrade the quality of your service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to home view directly (for testing)
                          // In production, this should go to login first
                          Navigator.pushReplacementNamed(context, '/home');

                          // Or if you want to keep welcome in stack:
                          // Navigator.pushNamed(context, '/home');

                          // Or if you want to go to login:
                          // Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Get started!',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
