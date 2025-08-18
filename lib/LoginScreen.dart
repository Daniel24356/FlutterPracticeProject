import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome Back 👋",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Card Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        onChanged: (val) => setState(() => email = val),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        onChanged: (val) => setState(() => password = val),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A3FFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/chat');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Color(0xFF7A3FFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
