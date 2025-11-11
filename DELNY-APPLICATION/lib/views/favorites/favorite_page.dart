import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import '../common/user_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: const Color(0xFFFB5E10),
      ),
      body: StreamBuilder<List<String>>(
        stream: provider.favoriteStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = snapshot.data ?? [];

          if (favoriteIds.isEmpty) {
            return const Center(child: Text("No favorites added yet."));
          }

          return FutureBuilder<List<dynamic>>(
            future: userService.getFavoriteUsers(favoriteIds),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = userSnapshot.data ?? [];

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Card(
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
                                Text("👤 ${user.name}",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("📞 ${user.phone}", style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text("📍 ${user.location}", style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text("💼 ${user.experience} years", style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () => provider.toggleFavorite(user.uid),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}