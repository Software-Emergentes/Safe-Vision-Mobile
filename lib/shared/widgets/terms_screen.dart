import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

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
              Center(
                child: Text('SafeVision', style: TextStyle(color: const Color(0xFFD81B60), fontWeight: FontWeight.w700, fontSize: 20)),
              ),
              const SizedBox(height: 12),
              // progress indicators (all three shown active to match attachment)
              Row(
                children: [
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD81B60), borderRadius: BorderRadius.circular(4)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD81B60), borderRadius: BorderRadius.circular(4)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD81B60), borderRadius: BorderRadius.circular(4)))),
                ],
              ),
              const SizedBox(height: 20),

              const Text('Terms & Conditions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      Text('1. Acceptance of Terms', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('By registering and using SafeVision, you agree to comply with these terms and conditions. If you do not agree with any of them, you will not be able to access or use our services.'),
                      SizedBox(height: 12),
                      Text('2. Account Registration', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('To access the platform, you must create an account by providing accurate, complete, and up-to-date information about your organization and fleet. You are responsible for maintaining the confidentiality of your credentials and the use of your account.'),
                      SizedBox(height: 12),
                      Text('3. Use of the Platform', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('SafeVision is designed to support fleet managers and transportation teams in the safe and efficient management of their vehicles. You agree to use the platform in a legal, responsible, and respectful manner, avoiding any activity that infringes on the rights of third parties or current regulations.'),
                      SizedBox(height: 12),
                      Text('4. Use of IoT and AI Devices', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text('The IoT devices installed in vehicles and SafeVision\'s Artificial Intelligence features collect, process, and analyze fleet driving and performance data. You are responsible for ensuring that the use of this data complies with the labor and privacy regulations applicable in your jurisdiction.'),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Go to account created confirmation screen
                    Navigator.pushReplacementNamed(context, '/account_created');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Accept & continue', style: TextStyle(color: Colors.white)),
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
