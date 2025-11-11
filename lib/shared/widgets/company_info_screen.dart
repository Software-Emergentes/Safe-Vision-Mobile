import 'package:flutter/material.dart';

class CompanyInfoScreen extends StatefulWidget {
  const CompanyInfoScreen({Key? key}) : super(key: key);

  @override
  State<CompanyInfoScreen> createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();
  final _rucCtrl = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_validate);
    _nickCtrl.addListener(_validate);
    _rucCtrl.addListener(_validate);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nickCtrl.dispose();
    _rucCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    final name = _nameCtrl.text.trim();
    final nick = _nickCtrl.text.trim();
    final ruc = _rucCtrl.text.trim();
    final valid = name.isNotEmpty && nick.isNotEmpty && ruc.isNotEmpty;
    if (valid != _isValid) setState(() => _isValid = valid);
  }

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
              const SizedBox(height: 16),
              // progress indicators (two completed, one current)
              Row(
                children: [
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD81B60), borderRadius: BorderRadius.circular(4)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD81B60), borderRadius: BorderRadius.circular(4)))),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Enter your transport company\'s information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Fill in the fields below', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(controller: _nameCtrl, hint: "Full company's name"),
                    const SizedBox(height: 12),
                    _buildField(controller: _nickCtrl, hint: "Company's nickname"),
                    const SizedBox(height: 12),
                    _buildField(controller: _rucCtrl, hint: "Company's RUC"),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Terms & Conditions even if fields are empty (per request)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceeding to Terms & Conditions')));
                    Navigator.pushNamed(context, '/terms');
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

  Widget _buildField({required TextEditingController controller, required String hint}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }
}
