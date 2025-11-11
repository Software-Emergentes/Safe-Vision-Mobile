import 'package:flutter/material.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              const Center(
                child: Text(
                  'Your account has been created',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Now you can start using SafeVision in your next trip!',
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // After creating account, go to select profile (or main flow)
                    Navigator.pushReplacementNamed(context, '/select_profile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Continue', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
