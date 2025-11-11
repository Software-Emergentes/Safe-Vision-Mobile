import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_validate);
    _lastNameCtrl.addListener(_validate);
    _dniCtrl.addListener(_validate);
    _emailCtrl.addListener(_validate);
    _phoneCtrl.addListener(_validate);
    _passwordCtrl.addListener(_validate);
    _confirmCtrl.addListener(_validate);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dniCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    final name = _nameCtrl.text.trim();
    final last = _lastNameCtrl.text.trim();
    final dni = _dniCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final pass = _passwordCtrl.text;
    final conf = _confirmCtrl.text;

    final emailOk = email.contains('@') && email.length > 3;
    final passOk = pass.length >= 6 && pass == conf;

    final valid = name.isNotEmpty && last.isNotEmpty && dni.isNotEmpty && emailOk && phone.isNotEmpty && passOk;

    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'SafeVision',
                    style: TextStyle(
                      color: const Color(0xFFD81B60),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // progress indicators (three steps look)
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD81B60), borderRadius: BorderRadius.circular(4))),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                    const SizedBox(width: 6),
                    Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
                  ],
                ),

                const SizedBox(height: 22),
                const Text('Enter your information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Fill in the fields below', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 18),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(controller: _nameCtrl, hint: 'Name'),
                      const SizedBox(height: 12),
                      _buildField(controller: _lastNameCtrl, hint: 'Last Name'),
                      const SizedBox(height: 12),
                      _buildField(controller: _dniCtrl, hint: 'DNI'),
                      const SizedBox(height: 12),
                      _buildField(controller: _emailCtrl, hint: 'Email', keyboard: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      _buildField(controller: _phoneCtrl, hint: 'Phone Number', keyboard: TextInputType.phone),
                      const SizedBox(height: 12),
                      _buildPasswordField(controller: _passwordCtrl, hint: 'Password', obscure: _obscurePassword, toggle: () => setState(() => _obscurePassword = !_obscurePassword)),
                      const SizedBox(height: 12),
                      _buildPasswordField(controller: _confirmCtrl, hint: 'Confirm your password', obscure: _obscureConfirm, toggle: () => setState(() => _obscureConfirm = !_obscureConfirm)),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to company info even if the form is empty (per request)
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceeding to company information')));
                      Navigator.pushNamed(context, '/company_info');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Continue', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({required TextEditingController controller, required String hint, TextInputType keyboard = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildPasswordField({required TextEditingController controller, required String hint, required bool obscure, required VoidCallback toggle}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility), onPressed: toggle),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Required';
        if (controller == _passwordCtrl && v.length < 6) return 'Minimum 6 characters';
        if (controller == _confirmCtrl && v != _passwordCtrl.text) return 'Passwords do not match';
        return null;
      },
    );
  }
}
