import 'package:flutter/material.dart';
// import 'package:projects/ProductDetailScreen.dart';
import 'OnboardingScreen.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';
import 'AppointmentPage.dart';
import 'PetDashboardApp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PawfectCare',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const PetDashboardApp(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen()
        // '/appointmentscreen': (context) => const AppointmentPage()
      },
    );
  }
}
