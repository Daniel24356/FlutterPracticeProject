import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';
import '../services/medicalRecordService.dart';

class Pet {
  final String id;
  final String name;
  final String image;
  Pet(this.id, this.name, this.image);
}

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({super.key});

  @override
  State<HealthRecordsPage> createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  Pet? selectedPet; // currently picked pet
  String? selectedCategory; // null = grid, not null = show records
  final MedicalRecordService _recordService = MedicalRecordService();

  void _showPetDropdown(BuildContext context) {
    // 🔥 Fetch pets dynamically for logged-in user
    final userId = FirebaseAuth.instance.currentUser!.uid;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("pets")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No pets found"));
            }

            final pets = snapshot.data!.docs;

            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index].data() as Map<String, dynamic>;
                final petId = pets[index].id;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: pet["photoUrl"] != null &&
                        pet["photoUrl"].toString().isNotEmpty
                        ? NetworkImage(pet["photoUrl"])
                        : const AssetImage("images/avatar.jpeg")
                    as ImageProvider,
                  ),
                  title: Text(
                    pet["name"] ?? "Unnamed",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPet = Pet(
                        petId,
                        pet["name"] ?? "Unnamed",
                        pet["photoUrl"] ?? "",
                      );
                      searchQuery = pet["name"] ?? "";
                      _searchController.clear();
                    });
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
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
                        backgroundImage: currentPet.image.isNotEmpty
                            ? NetworkImage(currentPet.image)
                            : const AssetImage("images/avatar.jpeg")
                        as ImageProvider,
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
                child: selectedPet == null
                    ? const Center(child: Text("Pick a pet to view records"))
                    : (selectedCategory == null
                    ? _buildCategoryGrid()
                    : _buildRecordsView(selectedCategory!, currentPet!)),
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

  /// Records View with Firebase
  Widget _buildRecordsView(String category, Pet pet) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("pets")
          .doc(pet.id)
          .collection("healthRecords")
          .where("category", isEqualTo: category)
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No records available"));
        }

        final records = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                  const Text("  >  ", style: TextStyle(fontSize: 20)),
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
            const SizedBox(height: 16),

            // Records list
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (_, i) {
                  final record =
                  records[i].data() as Map<String, dynamic>;

                  final date = (record["date"] as Timestamp?)?.toDate();

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
                            Text(
                              date != null
                                  ? "${date.day}/${date.month}/${date.year}"
                                  : "No date",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(record["diagnosis"] ?? "No title",
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(record["notes"] ?? "No details",
                                style: const TextStyle(color: Colors.grey)),
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
      },
    );
  }
}
