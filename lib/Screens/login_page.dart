import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // input formatters
import 'otp_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      final number = _phoneController.text.trim(); // 10-digit only
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(phoneNumber: number),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: orange,
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔶 Header Image (circle + shadow)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/puned.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Pune Ganpati Rescue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 📱 Mobile number (digits only, 10)
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "Ur Mobail No.",
                      prefixIcon:
                      const Icon(Icons.phone, color: Colors.deepOrange),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return "Enter mobile number";
                      if (t.length != 10) return "Enter 10-digit number";
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // 🔘 Send OTP
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _sendOtp,
                      child: const Text(
                        "Send OTP",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🆕 New Registration
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.app_registration_outlined),
                    label: const Text(
                      "New Registration",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "We’ll send a 6-digit OTP to verify.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
