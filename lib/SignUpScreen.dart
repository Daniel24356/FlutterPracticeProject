import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
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
                "Create Account ✨",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign up to get started",
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
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        onChanged: (val) => setState(() => name = val),
                      ),
                      const SizedBox(height: 16),
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
                          "Sign Up",
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
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  "Already have an account? Login",
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
