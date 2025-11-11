import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../home/choose_services_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user!;
      await user.reload();

      if (!user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please verify your email before logging in.")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final provider = context.read<UserProvider>();
      await provider.fetchUserData(user.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Choosetheservices()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: isPassword ? const Icon(Icons.lock) : const Icon(Icons.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color(0xFFFB5E10),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTextFormField(_emailController, "Email", keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _buildTextFormField(_passwordController, "Password", isPassword: true),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB5E10),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: const Text("Sign Up", style: TextStyle(color: Color(0xFFFB5E10))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}