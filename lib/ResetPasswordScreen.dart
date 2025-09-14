import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String otp = "";
  String oldPassword = "";
  String newPassword = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo + Title
              Column(
                children: const [
                  Icon(Icons.favorite_border,
                      color: Colors.green, size: 48),
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

              // Page Title
              const Text(
                "Reset Your Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Enter the OTP you received and set a new password",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Card
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
                      // OTP
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "OTP",
                          hintText: "Enter the code sent to your email",
                          prefixIcon: const Icon(Icons.verified_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) =>
                        val!.isEmpty ? "Enter the OTP" : null,
                        onChanged: (val) => setState(() => otp = val),
                      ),
                      const SizedBox(height: 16),

                      // Old Password
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Old Password",
                          hintText: "Enter your old password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val!.isEmpty
                            ? "Enter your old password"
                            : null,
                        onChanged: (val) => setState(() => oldPassword = val),
                      ),
                      const SizedBox(height: 16),

                      // New Password
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          hintText: "Enter your new password",
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (val) => val!.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
                        onChanged: (val) => setState(() => newPassword = val),
                      ),
                      const SizedBox(height: 24),

                      // Reset Button
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

                              try {
                                // Call your API here
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Password reset successfully!")),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error resetting password: $e")),
                                );
                              } finally {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Back to Login
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "← Back to Login",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF007BFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
