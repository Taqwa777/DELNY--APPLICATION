import 'package:final_project_dlny/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import '../common/user_detail_page.dart';
 
class BlacksmithPage extends StatelessWidget {
  const BlacksmithPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final userService = UserService(); // استخدم الخدمة مباشرة
 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blacksmiths"),
        backgroundColor: const Color(0xFFFB5E10),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: userService.getUsersByCareer('Blacksmith'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No blacksmiths available"));
          }
 
          final users = snapshot.data!;
 
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isFav = provider.isFavorite(user.uid);
 
              return _buildUserCard(user, isFav, provider, context);
            },
          );
        },
      ),
    );
  }
 
  Widget _buildUserCard(
      UserModel user,
      bool isFav,
      UserProvider provider,
      BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserDetailPage(user: user.toMap())),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("📞 ${user.phone ?? '-'}"),
                    const SizedBox(height: 6),
                    Text("📍 ${user.location ?? '-'}"),
                    const SizedBox(height: 6),
                    Text("💼 ${user.experience ?? '0'} years"),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                  size: 28,
                ),
                onPressed: () => provider.toggleFavorite(user.uid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}