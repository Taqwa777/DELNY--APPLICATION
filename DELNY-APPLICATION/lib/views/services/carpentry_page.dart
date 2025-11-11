import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../common/user_detail_page.dart';

class CarpentryPage extends StatelessWidget {
  const CarpentryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
          title: const Text("Carpenters"),
          backgroundColor: const Color(0xFFFB5E10)
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('career', isEqualTo: 'Carpentry')
            .where('isServiceProvider', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No carpenters available"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              user['uid'] = users[index].id;
              final isFav = provider.isFavorite(user['uid']);

              return _buildUserCard(user, isFav, provider, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(
      Map<String, dynamic> user,
      bool isFav,
      UserProvider provider,
      BuildContext context
      ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserDetailPage(user: user)),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("👤 ${user['name']}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("📞 ${user['phone']}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 6),
                    Text("📍 ${user['location']}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 6),
                    Text("💼 ${user['experience']} years", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
                onPressed: () => provider.toggleFavorite(user['uid']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}