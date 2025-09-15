import 'package:flutter/material.dart';
import 'package:projects/services/authService.dart';
import 'PetDashboardApp.dart';
import 'VetDashboard.dart';
import 'ShelterDashboard.dart';

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
  String phone = "";
  String role = "Pet Owner";
  bool isLoading = false;
  bool _obscurePassword = true;

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
              const Icon(Icons.pets, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              const Text(
                "PawfectCare",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text("Create Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text("Sign up to get started", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Full Name", prefixIcon: const Icon(Icons.person_outline), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                        validator: (val) => val!.isEmpty ? "Enter your name" : null,
                        onChanged: (val) => setState(() => name = val),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Email", prefixIcon: const Icon(Icons.email_outlined), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                        validator: (val) => val!.isEmpty ? "Enter your email" : null,
                        onChanged: (val) => setState(() => email = val),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        validator: (val) => val!.length < 6 ? "Password too short" : null,
                        onChanged: (val) => setState(() => password = val),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Phone Number", prefixIcon: const Icon(Icons.phone_outlined), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                        validator: (val) => val!.isEmpty ? "Enter your phone number" : null,
                        onChanged: (val) => setState(() => phone = val),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: role,
                        items: const [
                          DropdownMenuItem(value: "Pet Owner", child: Text("Pet Owner")),
                          DropdownMenuItem(value: "Veterinarian", child: Text("Veterinarian")),
                          DropdownMenuItem(value: "Animal Shelter", child: Text("Animal Shelter")),
                        ],
                        onChanged: (val) => setState(() => role = val!),
                        decoration: InputDecoration(labelText: "Select Role", filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);

                              final user = await AuthService().signUp(
                                  name: name.trim(),
                                  email: email.trim(),
                                  password: password,
                                  phone: phone.trim(),
                                  role: role);

                              setState(() => isLoading = false);

                              if (user != null) {
                                // Navigate based on role
                                if (role == "Pet Owner") {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PetDashboardApp()));
                                } else if (role == "Veterinarian") {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VetDashboard()));
                                } else if (role == "Animal Shelter") {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ShelterDashboard()));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign up failed")));
                              }
                            }
                          },
                          child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text("← Back to Login", style: TextStyle(fontSize: 14, color: Color(0xFF007BFF))),
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

// import 'package:flutter/material.dart';
// import 'package:projects/services/authService.dart';
// import 'PetDashboardApp.dart';
// import 'VetDashboard.dart';
// import 'ShelterDashboard.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String name = "";
//   String email = "";
//   String password = "";
//   String phone = "";
//   String role = "Pet Owner";
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6FAFF),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.pets, color: Colors.green, size: 48),
//               const SizedBox(height: 8),
//               const Text(
//                 "PawfectCare",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
//               ),
//               const SizedBox(height: 20),
//               const Text("Create Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 6),
//               const Text("Sign up to get started", style: TextStyle(color: Colors.grey, fontSize: 14)),
//               const SizedBox(height: 30),
//
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(labelText: "Full Name", prefixIcon: const Icon(Icons.person_outline), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
//                         validator: (val) => val!.isEmpty ? "Enter your name" : null,
//                         onChanged: (val) => setState(() => name = val),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(labelText: "Email", prefixIcon: const Icon(Icons.email_outlined), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
//                         validator: (val) => val!.isEmpty ? "Enter your email" : null,
//                         onChanged: (val) => setState(() => email = val),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         obscureText: true,
//                         decoration: InputDecoration(labelText: "Password", prefixIcon: const Icon(Icons.lock_outline), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
//                         validator: (val) => val!.length < 6 ? "Password too short" : null,
//                         onChanged: (val) => setState(() => password = val),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(labelText: "Phone Number", prefixIcon: const Icon(Icons.phone_outlined), filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
//                         validator: (val) => val!.isEmpty ? "Enter your phone number" : null,
//                         onChanged: (val) => setState(() => phone = val),
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<String>(
//                         value: role,
//                         items: const [
//                           DropdownMenuItem(value: "Pet Owner", child: Text("Pet Owner")),
//                           DropdownMenuItem(value: "Veterinarian", child: Text("Veterinarian")),
//                           DropdownMenuItem(value: "Animal Shelter", child: Text("Animal Shelter")),
//                         ],
//                         onChanged: (val) => setState(() => role = val!),
//                         decoration: InputDecoration(labelText: "Select Role", filled: true, fillColor: const Color(0xFFF8F9FA), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
//                       ),
//                       const SizedBox(height: 20),
//
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                           onPressed: isLoading
//                               ? null
//                               : () async {
//                             if (_formKey.currentState!.validate()) {
//                               setState(() => isLoading = true);
//
//                               final user = await AuthService().signUp(
//                                   name: name.trim(),
//                                   email: email.trim(),
//                                   password: password,
//                                   phone: phone.trim(),
//                                   role: role);
//
//                               setState(() => isLoading = false);
//
//                               if (user != null) {
//                                 // Navigate based on role
//                                 if (role == "Pet Owner") {
//                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PetDashboardApp()));
//                                 } else if (role == "Veterinarian") {
//                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VetDashboard()));
//                                 } else if (role == "Animal Shelter") {
//                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ShelterDashboard()));
//                                 }
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign up failed")));
//                               }
//                             }
//                           },
//                           child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text("← Back to Login", style: TextStyle(fontSize: 14, color: Color(0xFF007BFF))),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
