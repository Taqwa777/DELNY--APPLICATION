import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../services/blacksmith_page.dart';
import '../services/plumbing_page.dart';
import '../services/painting_page.dart';
import '../services/carpentry_page.dart';
import '../favorites/favorite_page.dart';
import '../profile/profile_page.dart';

class Choosetheservices extends StatefulWidget {
  const Choosetheservices({super.key});

  @override
  State<Choosetheservices> createState() => _ChoosetheservicesState();
}

class _ChoosetheservicesState extends State<Choosetheservices> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> services = [
    {
      "label": "Carpentry service",
      "imagePath": "assets/image_choose/IMG_7561.JPG",
      "page": const CarpentryPage(),
    },
    {
      "label": "Blacksmith service",
      "imagePath": "assets/image_choose/IMG_7559.JPG",
      "page": const BlacksmithPage(),
    },
    {
      "label": "Plumbing service",
      "imagePath": "assets/image_choose/IMG_7560.JPG",
      "page": const PlumbingPage(),
    },
    {
      "label": "Painting service",
      "imagePath": "assets/image_choose/IMG_7562.JPG",
      "page": const PaintingPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      const FavoritePage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB5E10),
        title: Text(
          _selectedIndex == 0 ? "Choose a Service" :
          _selectedIndex == 1 ? "Favorites" : "Profile",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFB5E10),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What service do you need?",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFB5E10),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(
                  imagePath: services[index]["imagePath"],
                  label: services[index]["label"],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => services[index]["page"]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color.fromARGB(255, 17, 14, 103),
            width: 4,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color.fromARGB(255, 17, 14, 103),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}