import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'OnboardingScreen.dart';
import 'OnboardingFlow.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';
import 'PetDashboardApp.dart';
import 'ForgotPasswordScreen.dart';
import 'ResetPasswordScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/onboarding1': (context) => const OnboardingFlow(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/resetPassword': (context) => const ResetPasswordScreen(),
        '/petDashboardApp': (context) => const PetDashboardApp(),
      },
    );
  }
}
