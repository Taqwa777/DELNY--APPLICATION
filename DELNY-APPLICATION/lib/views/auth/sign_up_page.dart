import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'email_verification_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isServiceProvider = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: "962");
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _selectedCareer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user!;
      final userId = user.uid;

      await user.sendEmailVerification();

      String phoneNumber = "";
      if (_isServiceProvider) {
        final cleanNumber = _phoneController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
        phoneNumber = "${_countryCodeController.text.trim()}$cleanNumber";
      }

      final userData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'isServiceProvider': _isServiceProvider,
        'favorites': [],
      };

      if (_isServiceProvider) {
        userData.addAll({
          'phone': phoneNumber,
          'career': _selectedCareer ?? '',
          'location': _locationController.text.trim(),
          'experience': _experienceController.text.trim(),
        });
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).set(userData);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Error signing up")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextFormField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
        bool isRequired = false,
        bool obscureText = false,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: const Color(0xFFFB5E10),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(_nameController, "Full Name", isRequired: true),
              const SizedBox(height: 12),
              _buildTextFormField(
                _emailController,
                "Email",
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please enter Password";
                  if (value.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _isServiceProvider,
                    onChanged: (v) => setState(() => _isServiceProvider = v ?? false),
                  ),
                  const Text("Are you a service provider?"),
                ],
              ),
              if (_isServiceProvider) ...[
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextFormField(
                        _countryCodeController,
                        "Country Code",
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: _buildTextFormField(
                        _phoneController,
                        "Phone Number",
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCareer,
                  decoration: const InputDecoration(
                    labelText: "Career / Profession",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Carpentry", child: Text("Carpenter")),
                    DropdownMenuItem(value: "Blacksmith", child: Text("Blacksmith")),
                    DropdownMenuItem(value: "Plumbing", child: Text("Plumber")),
                    DropdownMenuItem(value: "Painting", child: Text("Painter")),
                  ],
                  onChanged: (v) => setState(() => _selectedCareer = v),
                  validator: (v) => _isServiceProvider && (v == null || v.isEmpty)
                      ? "Please select profession"
                      : null,
                ),
                const SizedBox(height: 12),
                _buildTextFormField(_locationController, "Work Location", isRequired: true),
                const SizedBox(height: 12),
                _buildTextFormField(
                  _experienceController,
                  "Years of Experience",
                  keyboardType: TextInputType.number,
                  isRequired: true,
                ),
              ],
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB5E10),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _isLoading ? null : _signUp,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}