import 'package:flutter/material.dart';
import 'package:projects/PetDashboardApp.dart';
import 'package:projects/VetDashboard.dart';
import 'package:projects/services/authService.dart';

import 'ShelterDashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String fullName = "";
  String email = "";
  String phone = "";
  String password = "";
  String confirmPassword = "";
  String? selectedRole;

  final List<String> roles = [
    "Pet Owner",
    "Veterinarian",
    "Animal Shelter",
  ];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo + App Name
              Column(
                children: const [
                  Icon(Icons.favorite_border, color: Colors.green, size: 48),
                  SizedBox(height: 8),
                  Text(
                    "PawfectCare",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                "Join the PawfectCare community",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          hintText: "Enter your full name",
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) =>
                        val!.isEmpty ? "Enter your full name" : null,
                        onChanged: (val) => setState(() => fullName = val),
                      ),
                      const SizedBox(height: 16),
                      // Email
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) =>
                        val!.isEmpty ? "Enter your email" : null,
                        onChanged: (val) => setState(() => email = val),
                      ),
                      const SizedBox(height: 16),
                      // Phone
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          hintText: "Enter your phone number",
                          prefixIcon: const Icon(Icons.phone_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) =>
                        val!.isEmpty ? "Enter your phone number" : null,
                        onChanged: (val) => setState(() => phone = val),
                      ),
                      const SizedBox(height: 16),
                      // Role Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        hint: const Text("Select your role"),
                        items: roles
                            .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                            .toList(),
                        validator: (val) => val == null ? "Select a role" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.pets_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) => setState(() => selectedRole = val),
                      ),
                      const SizedBox(height: 16),
                      // Password
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Create a password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) =>
                        val!.length < 6 ? "Password too short" : null,
                        onChanged: (val) => setState(() => password = val),
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          hintText: "Confirm your password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) =>
                        val != password ? "Passwords do not match" : null,
                        onChanged: (val) =>
                            setState(() => confirmPassword = val),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              final user = await AuthService().signUp(
                                name: fullName.trim(),
                                email: email.trim(),
                                password: password,
                                phone: phone.trim(),
                                role: selectedRole!,
                              );

                              setState(() => isLoading = false);

                              if (user != null) {
                                // Role-based navigation
                                if (selectedRole == 'Pet Owner') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            PetDashboardApp()),
                                  );
                                } else if (selectedRole ==
                                    'Veterinarian') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => VetDashboard()),
                                  );
                                } else if (selectedRole ==
                                    'Animal Shelter') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ShelterDashboard()),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:
                                    Text('Sign Up Failed')));
                              }
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
