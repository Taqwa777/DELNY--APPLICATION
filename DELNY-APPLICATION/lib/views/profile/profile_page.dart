import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSaving = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _careerController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final provider = context.read<UserProvider>();
    final user = provider.user;

    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _careerController.text = user.career ?? '';
      _locationController.text = user.location ?? '';
      _experienceController.text = user.experience ?? '';
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = context.read<UserProvider>();

    final updates = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'career': _careerController.text.trim(),
      'location': _locationController.text.trim(),
      'experience': _experienceController.text.trim(),
    };

    try {
      await provider.updateProfile(updates);
      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ التعديلات بنجاح ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    final provider = context.read<UserProvider>();
    await FirebaseAuth.instance.signOut();
    provider.clearData();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  Widget _buildInfoField(String label, IconData icon, TextEditingController controller,
      {bool enabled = true}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFB5E10)),
        title: TextFormField(
          controller: controller,
          enabled: _isEditing && enabled,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final user = provider.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFFFB5E10),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              _buildInfoField("Name", Icons.person, _nameController),



              if (user.isServiceProvider) ...[
                _buildInfoField("Phone", Icons.phone, _phoneController),
                _buildInfoField("Career", Icons.work, _careerController),
                _buildInfoField("Location", Icons.location_on, _locationController),
                _buildInfoField("Experience", Icons.school, _experienceController),
              ],
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Color(0xFFFB5E10)),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(user.email, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _isEditing ? _saveChanges : () => setState(() => _isEditing = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? const Color(0xFFFB5E10) : Colors.grey[700],
                  minimumSize: const Size(double.infinity, 50),
                ),

                icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
                label: Text(
                  _isEditing ? (_isSaving ? "Saving..." : "Save") : "Edit",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}