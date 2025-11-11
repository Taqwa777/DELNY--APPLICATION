import 'package:flutter/material.dart';

import '../auth/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/image.jpg",
      "title": "Welcome to Dlny App",
      "description": "Find trusted craftsmen and engineers anytime, anywhere.",
    },
    {
      "image": "assets/images/imagee.jpeg",
      "title": "Best Services",
      "description": "We offer a wide range of services to help you get work done efficiently and with high quality.",
    },
    {
      "image": "assets/images/image0.jpeg",
      "title": "Start Now",
      "description": "Join us today and enjoy a smooth and comfortable experience every step of the way.",
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1000;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.06,
                          vertical: size.height * 0.04,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.02),
                            ClipOval(
                              child: Container(
                                width: isDesktop
                                    ? size.width * .25
                                    : isTablet
                                    ? size.width * 0.4
                                    : size.width * 0.6,
                                height: isDesktop
                                    ? size.width * 0.25
                                    : isTablet
                                    ? size.width * 0.4
                                    : size.width * 0.6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  onboardingData[index]["image"]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Text(
                              onboardingData[index]["title"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 36
                                    : isTablet
                                    ? 28
                                    : size.width * 0.07,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 14, 14, 14),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Text(
                              onboardingData[index]["description"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 20
                                    : isTablet
                                    ? 18
                                    : size.width * 0.045,
                                color: const Color.fromARGB(255, 14, 13, 13).withOpacity(0.9),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: _currentPage == index ? 25 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color.fromARGB(255, 250, 94, 16)
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 250, 94, 16),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet
                              ? size.height * 0.025
                              : size.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                      child: Text(
                        _currentPage == onboardingData.length - 1
                            ? "Get Started"
                            : "Continue",
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 22
                              : isTablet
                              ? 20
                              : size.width * 0.045,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}