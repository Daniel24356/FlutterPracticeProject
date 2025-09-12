import 'package:flutter/material.dart';

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({super.key});

  @override
  State<HealthRecordsPage> createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  String selectedPet = "All Pets";
  int selectedTab = 2; // 0 = Vaccinations, 1 = Medical, 2 = Medications

  final List<Map<String, dynamic>> records = [
    {
      "title": "Heartgard Plus",
      "subtitle": "Max • Heartworm Prevention",
      "status": "Active",
      "statusColor": Colors.green,
      "dosage": "25mg monthly",
      "duration": "2024-03-01 • 2025-03-01",
      "doctor": "Dr. Smith",
      "instructions": "Give one chewable tablet monthly with food"
    },
    {
      "title": "Metacam",
      "subtitle": "Coco • Pain Relief",
      "status": "Completed",
      "statusColor": Colors.blue,
      "dosage": "0.5ml daily",
      "duration": "2024-08-01 • 2024-08-15",
      "doctor": "Dr. Johnson",
      "instructions": "Give orally once daily for 2 weeks"
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                        "Health Records",
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
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search + Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search records...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPet,
                    items: ["All Pets", "Max", "Coco"]
                        .map((pet) =>
                        DropdownMenuItem(value: pet, child: Text(pet)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => selectedPet = val ?? "All Pets");
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTab("Vaccinations", 0),
                  _buildTab("Medical", 1),
                  _buildTab("Medications", 2),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Records List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return _buildRecordCard(record);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = selectedTab == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => selectedTab = index),
      selectedColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.medical_services, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record["title"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(record["subtitle"],
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: record["statusColor"].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    record["status"],
                    style: TextStyle(
                      color: record["statusColor"],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text("Dosage", style: TextStyle(color: Colors.grey[600])),
            Text(record["dosage"], style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 8),
            Text("Duration", style: TextStyle(color: Colors.grey[600])),
            Text(record["duration"], style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 8),
            Text("Prescribed By", style: TextStyle(color: Colors.grey[600])),
            Text(record["doctor"], style: const TextStyle(fontSize: 14)),

            const Divider(height: 24),

            Text("Instructions", style: TextStyle(color: Colors.grey[600])),
            Text(record["instructions"], style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
