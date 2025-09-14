import 'package:flutter/material.dart';

import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Pet> pets = [
    Pet("Max", "images/maltese.png"),
    Pet("Luna", "images/luna.jpg"),
    Pet("Dash", "images/dash.jpg"),
    Pet("Tom", "images/tom.jpg"),
  ];

  Pet? selectedPet; // New: currently picked pet
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
        "details": "Teeth cleaning under anesthesia.\nDoctor: Dr. Brown."
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

  void _showPetDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // so we can control height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4, // reduce modal height
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 28, // increase image size
                    backgroundImage: AssetImage(pet.image),
                  ),
                  title: Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 18, // bigger text
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPet = pet;
                      searchQuery = pet.name;
                      _searchController.clear();
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final currentPet = selectedPet;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Health Records",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Filter records by pet...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () => _showPetDropdown(context),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🟢 Selected pet pill
            if (currentPet != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: CircleAvatar(
                        backgroundImage: AssetImage(currentPet.image),
                      ),
                      label: Text(currentPet.name),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() => selectedPet = null);
                      },
                    ),
                  ],
                ),
              ),

            // 📝 Context message
            if (currentPet != null)
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Currently viewing ${currentPet.name}'s Records",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Category / Records area
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
              style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
        Container(
          // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
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
              const Text(
                "  >  ",
                style: TextStyle(fontSize: 20),
              ),
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
        ),
        SizedBox(height: 16),

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
