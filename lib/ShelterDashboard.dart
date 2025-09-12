import 'package:flutter/material.dart';

class ShelterDashboard extends StatelessWidget {
  const ShelterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animal Shelter Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          "Welcome to the Animal Shelter Dashboard",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
