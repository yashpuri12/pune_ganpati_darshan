import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_home.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = 30;
  bool _resending = false;
  bool _verifying = false;

  String get _maskedPhone {
    final p = widget.phoneNumber.replaceAll(RegExp(r'\s+'), '');
    if (p.length <= 4) return p;
    final last4 = p.substring(p.length - 4);
    return '••••••$last4';
  }

  bool get _isValidOtp => _otpController.text.trim().length == 6;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown({int from = 30}) {
    _timer?.cancel();
    setState(() => _secondsLeft = from);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_secondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    await Future.delayed(const Duration(seconds: 2)); // mock API
    if (!mounted) return;
    setState(() => _resending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("New OTP sent to ${widget.phoneNumber} ✅")),
    );
    _startCountdown(from: 30);
  }

  Future<void> _verify() async {
    if (!_isValidOtp || _verifying) return;
    setState(() => _verifying = true);

    final otp = _otpController.text.trim();
    await Future.delayed(const Duration(milliseconds: 300)); // tiny UX delay

    if (!mounted) return;
    if (otp == "123456") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainHome()),
            (route) => false,
      );
    } else {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: orange,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Edit number", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "OTP sent to $_maskedPhone",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _otpController,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Enter OTP",
                prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
                counterText: "",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isValidOtp ? orange : Colors.orange.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isValidOtp && !_verifying ? _verify : null,
                child: _verifying
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    // NOTE: deliberately no valueColor / no const anywhere here
                  ),
                )
                    : const Text("Verify OTP"),
              ),
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                const Text(
                  "Didn't receive the code?",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: (_secondsLeft == 0 && !_resending) ? _resendOtp : null,
                  child: _resending
                      ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(
                    _secondsLeft == 0 ? "Resend OTP" : "Resend in ${_secondsLeft}s",
                    style: TextStyle(
                      color: _secondsLeft == 0 ? orange : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
