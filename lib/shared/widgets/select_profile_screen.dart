import 'package:flutter/material.dart';

class SelectProfileScreen extends StatelessWidget {
  const SelectProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'SafeVision',
                  style: TextStyle(
                    color: const Color(0xFFD81B60),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Select your profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose the profile that best suits you',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),

              const SizedBox(height: 24),

              // Buttons
              _OutlinedOption(
                label: 'Professional Driver',
                onTap: () {
                  // Navigate to sign up to enter information for driver
                  Navigator.pushNamed(context, '/sign_up');
                },
              ),
              const SizedBox(height: 12),
              _OutlinedOption(
                label: 'Fleet Manager',
                onTap: () {
                  // Navigate to sign up to enter information for manager
                  Navigator.pushNamed(context, '/sign_up');
                },
              ),

              const Spacer(),

              Center(
                child: GestureDetector(
                  onTap: () {
                    // navigate back to login
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedOption({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: Colors.black54),
          backgroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }
}
