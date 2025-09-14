import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: HealthRecordsPage()));
}

class Pet {
  final String name;
  final String image;
  Pet(this.name, this.image);
}

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({super.key});

  @override
  State<HealthRecordsPage> createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  final List<Pet> pets = [
    Pet("Max", "images/maltese.png"),
    Pet("Luna", "images/luna.jpg"),
    Pet("Dash", "images/dash.jpg"),
    Pet("Tom", "images/tom.jpg"),
  ];

  int selectedPetIndex = 0; // Default: first pet
  String? selectedCategory; // null = show grid, not null = show records

  final Map<String, List<Map<String, String>>> exampleRecords = {
    "Surgeries": [
      {
        "date": "2024-09-01",
        "title": "Knee Surgery",
        "details":
        "Procedure done at Downtown Vet Clinic.\nRecovery time: 6 weeks."
      },
      {
        "date": "2023-11-15",
        "title": "Dental Surgery",
        "details":
        "Teeth cleaning under anesthesia.\nDoctor: Dr. Brown."
      },
    ],
    "Vaccinations": [
      {
        "date": "2024-02-10",
        "title": "Rabies Vaccine",
        "details": "Annual booster shot.\nDoctor: Dr. White."
      }
    ],
    "Medications": [],
    "Allergies": [],
  };

  @override
  Widget build(BuildContext context) {
    final currentPet = pets[selectedPetIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                      const Text(
                        "Health Records ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add Record"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pets Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  for (int i = 0; i < pets.length; i++)
                    GestureDetector(
                      onTap: () => setState(() => selectedPetIndex = i),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedPetIndex == i
                                    ? Colors.green
                                    : Colors.transparent,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(pets[i].image),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            pets[i].name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Add Pet Button
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle,
                            size: 40, color: Colors.green),
                      ),
                      const SizedBox(height: 6),
                      const Text("Add"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Toggle between Category Grid and Records View
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: selectedCategory == null
                    ? _buildCategoryGrid()
                    : _buildRecordsView(selectedCategory!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Category Grid
  Widget _buildCategoryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildCategoryCard("Vaccinations", "images/vaccine.png"),
        _buildCategoryCard("Medications", "images/medicine.png"),
        _buildCategoryCard("Allergies", "images/allergy.png"),
        _buildCategoryCard("Surgeries", "images/surgery.png"),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String image) {
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 100, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Records View with Breadcrumb
  Widget _buildRecordsView(String category) {
    final records = exampleRecords[category] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => selectedCategory = null),
              child: const Text(
                "Records",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text("  >  "),
            Text(
              category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Records list
        Expanded(
          child: records.isEmpty
              ? const Center(
            child: Text("No records available"),
          )
              : ListView.builder(
            itemCount: records.length,
            itemBuilder: (_, i) {
              final record = records[i];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (i != records.length - 1)
                        Container(
                          width: 2,
                          height: 60,
                          color: Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record["date"]!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text(record["title"]!,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(record["details"]!,
                            style:
                            const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
