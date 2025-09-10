import 'package:flutter/material.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  static const Color primaryColor = Color(0xFF0DB14C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: const [
              Icon(Icons.favorite, color: primaryColor),
              SizedBox(width: 8),
              Text(
                "Add New Pet",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Pet Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Please provide details about your pet to create their profile",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name & Species
                  Row(
                    children: [
                      Expanded(
                          child:
                          _buildTextField("Pet Name *", "Enter pet name")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          "Species *",
                          ["Dog", "Cat", "Rabbit", "Bird", "Hamster", "Other"],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Breed & Age
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField("Breed", "Enter breed")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField("Age *", "e.g., 2 years")),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gender, Weight, Color
                  Row(
                    children: [
                      Expanded(
                        child:
                        _buildDropdown("Gender *", ["Male", "Female"]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField("Weight", "e.g., 5 kg")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField("Color", "e.g., Golden")),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Microchip
                  _buildTextField(
                      "Microchip ID", "Enter microchip ID (if available)"),
                  const SizedBox(height: 16),

                  // Photo upload placeholder
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pet Photo",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.upload, size: 36, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              "Click to upload a photo of your pet",
                              style:
                              TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  _buildTextField("Additional Notes",
                      "Any additional info...", maxLines: 3),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Add Pet"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: const BorderSide(color: Colors.grey),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widgets
  static Widget _buildTextField(String label, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  static Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: (_) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
