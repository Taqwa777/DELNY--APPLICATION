import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isVerified = false;
  bool _isSending = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _checkVerificationStatus();
  }

  Future<void> _checkVerificationStatus() async {
    await _user.reload();
    setState(() {
      _isVerified = _user.emailVerified;
    });

    if (_isVerified && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isSending = true);
    try {
      await _user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email resent.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: const Color(0xFFFB5E10),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 80, color: Color(0xFFFB5E10)),
              const SizedBox(height: 20),
              const Text(
                "A verification link has been sent to your email.\n"
                    "Please check your inbox and verify your account.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSending ? null : _resendVerificationEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB5E10),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Resend Verification Email"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkVerificationStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("I've Verified My Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}