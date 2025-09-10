import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController firstNameController =
  TextEditingController(text: "Usman");
  final TextEditingController lastNameController =
  TextEditingController(text: "Irfan");
  final TextEditingController emailController =
  TextEditingController(text: "usmanirfan123@gmail.com");
  final TextEditingController phoneController =
  TextEditingController(text: "+880 1234567890");

  String selectedCountry = "Bangladesh";
  String selectedCity = "Dhaka";

  // Pick image from gallery/camera
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });

      // ✅ Auto-save image instantly
      _saveProfileImage(_profileImage!);
    }
  }

  void _saveProfileImage(File image) {
    // TODO: Upload/save logic (API or local storage)
    debugPrint("Profile image saved: ${image.path}");
  }

  void _saveForm() {
    // ✅ Save form contents (simulate API call)
    debugPrint("Saving profile...");
    debugPrint("First Name: ${firstNameController.text}");
    debugPrint("Last Name: ${lastNameController.text}");
    debugPrint("Country: $selectedCountry");
    debugPrint("City: $selectedCity");
    debugPrint("Email: ${emailController.text}");
    debugPrint("Phone: ${phoneController.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image with camera button
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage("images/avatar.jpeg") as ImageProvider,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.camera_alt,
                        size: 18, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // First & Last Name
            Row(
              children: [
                Expanded(
                  child: _buildTextField("First Name", firstNameController),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField("Last Name", lastNameController),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Country & City Dropdowns
            Row(
              children: [
                Expanded(
                  child: _buildDropdown("Country", selectedCountry,
                      ["Bangladesh", "India", "USA"],
                          (val) => setState(() => selectedCountry = val!)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                      "City", selectedCity, ["Dhaka", "Chittagong", "Sylhet"],
                          (val) => setState(() => selectedCity = val!)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildTextField("Email", emailController),
            const SizedBox(height: 16),
            _buildTextField("Phone", phoneController),
            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0DB14C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6), // 👈 space between label and field
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 12), // tighter padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6), // 👈 space between label and dropdown
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map((e) =>
              DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}