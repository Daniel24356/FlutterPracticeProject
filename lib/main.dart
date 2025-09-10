import 'package:flutter/material.dart';
import 'package:projects/HealthRecordsScreen.dart';
// import 'package:projects/ProductDetailScreen.dart';
import 'ChatAppScreen.dart';
import 'OnboardingScreen.dart';
import 'ChatListScreen.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const HealthRecordsScreen()
        // '/login': (context) => const LoginScreen(),
        // '/signup': (context) => const SignUpScreen(),
        // '/chat': (context) => const ChatListScreen(),
        // '/chatPages': (context) => ChatPage(),
      },
    );
  }
}
