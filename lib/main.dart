import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'OnboardingScreen.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';
import 'AppointmentPage.dart';
import 'PetDashboardApp.dart';
import 'ForgotPasswordScreen.dart';

void main() async {
  // Make sure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PawfectCare',
      theme: ThemeData(
        primaryColor: const Color(0xFF0db14c), // Your green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0db14c),
          primary: const Color(0xFF0db14c),
        ),
        useMaterial3: true, // optional modern Material 3 look
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/petDashboardApp': (context) => const PetDashboardApp(),
        // '/appointmentscreen': (context) => const AppointmentPage(),
      },
    );
  }
}
