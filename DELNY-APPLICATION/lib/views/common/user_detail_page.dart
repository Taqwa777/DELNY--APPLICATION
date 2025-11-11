import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailPage({super.key, required this.user});

  Future<void> _openWhatsApp(String phone, BuildContext context) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/${phone.replaceAll('+', '')}");
    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp')),
      );
    }
  }

  Future<void> _makePhoneCall(String phone, BuildContext context) async {
    final Uri phoneUrl = Uri.parse("tel:$phone");
    try {
      await launchUrl(phoneUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make a call')),
      );
    }
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: const Color(0xFFFB5E10)),
          if (icon != null) const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = user['phone'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        backgroundColor: const Color(0xFFFB5E10),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFFFB5E10),
                        child: Text(
                          user['name'] != null && user['name'].isNotEmpty
                              ? user['name'][0].toUpperCase()
                              : "?",
                          style: const TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        user['name'] ?? "Unknown",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        user['career'] ?? "No profession",
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),
                    _buildInfoRow("Phone", user['phone'] ?? "-", icon: Icons.phone),
                    _buildInfoRow("Location", user['location'] ?? "-", icon: Icons.location_on),
                    _buildInfoRow("Experience", "${user['experience'] ?? '-'} years", icon: Icons.work),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 130),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (phone.isNotEmpty) {
                            _openWhatsApp(phone, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No phone number available')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB5E10),
                        ),
                        child: const Text("WhatsApp"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (phone.isNotEmpty) {
                            _makePhoneCall(phone, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No phone number available')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB5E10),
                        ),
                        child: const Text("Call"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
