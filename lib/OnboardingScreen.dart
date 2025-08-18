import 'package:flutter/material.dart';

void main() => runApp(const OnboardingApp());

class OnboardingApp extends StatelessWidget {
  const OnboardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top image section
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/onboard.png'), // 👈 Replace with your asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Bottom white section
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Enjoy the new experience of\nchating with global friends",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Connect people arround the world for free",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 45),

                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A3FFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Powered by section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Powered by "),
                        Image.asset(
                          'images/usage.png', // 👈 Replace with your actual logo image
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                      ],
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
