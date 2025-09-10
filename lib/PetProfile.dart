import 'package:flutter/material.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF0DB14C);

  @override
  Widget build(BuildContext context) {
    // Mock data for design
    final pet = {
      "name": "Max",
      "species": "Dog",
      "breed": "Golden Retriever",
      "age": "3 years",
      "gender": "Male",
      "weight": "25 kg",
      "color": "Golden",
      "microchipId": "123456789",
      "status": "Healthy",
      "photo": "🐕",
    };

    final vaccinations = [
      {"name": "Rabies", "date": "2024-01-15", "next": "2025-01-15", "status": "Up to date"},
      {"name": "DHPP", "date": "2024-02-10", "next": "2025-02-10", "status": "Up to date"},
      {"name": "Bordetella", "date": "2023-11-20", "next": "2024-11-20", "status": "Due Soon"},
    ];

    final healthRecords = [
      {"date": "2024-08-15", "type": "Checkup", "vet": "Dr. Smith", "notes": "General health checkup - all good"},
      {"date": "2024-06-10", "type": "Vaccination", "vet": "Dr. Johnson", "notes": "Annual vaccinations completed"},
      {"date": "2024-03-22", "type": "Dental", "vet": "Dr. Smith", "notes": "Dental cleaning performed"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(pet["photo"]!, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                Text(pet["breed"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.edit, size: 18, color: Colors.white),
            label: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(pet["photo"]!, style: const TextStyle(fontSize: 36)),
                      ),
                      Text(pet["name"]!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("${pet["breed"]} • ${pet["age"]}", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(pet["status"]!),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 3,
                        children: [
                          _infoTile("Species", pet["species"]!),
                          _infoTile("Gender", pet["gender"]!),
                          _infoTile("Weight", pet["weight"]!),
                          _infoTile("Color", pet["color"]!),
                        ],
                      ),
                      const Divider(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Microchip ID", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(pet["microchipId"]!, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            icon: const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                            label: const Text("Book Appointment"),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            icon: const Icon(Icons.camera_alt, size: 18),
                            label: const Text("Add Photo"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Right column
            Expanded(
              flex: 2,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TabBar(
                        labelColor: primaryColor,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: primaryColor,
                        tabs: [
                          Tab(icon: Icon(Icons.favorite), text: "Health"),
                          Tab(icon: Icon(Icons.description), text: "Records"),
                          Tab(icon: Icon(Icons.calendar_month), text: "Appointments"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Health tab
                          ListView(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Vaccination Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      const Text("Keep track of your pet's immunizations", style: TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 16),
                                      ...vaccinations.map((v) => Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(v["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                Text("Last: ${v["date"]}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                                Text("Next: ${v["next"]}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                              ],
                                            ),
                                            Chip(
                                              label: Text(v["status"]!),
                                              backgroundColor: v["status"] == "Up to date"
                                                  ? Colors.grey.shade200
                                                  : Colors.red.shade100,
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Records tab
                          ListView(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Medical History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      const Text("Complete health records and veterinary visits", style: TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 16),
                                      ...healthRecords.map((r) => Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(r["type"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                Chip(label: Text(r["date"]!)),
                                              ],
                                            ),
                                            Text("Dr: ${r["vet"]}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                            Text(r["notes"]!, style: const TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Appointments tab
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                                const SizedBox(height: 12),
                                const Text("No upcoming appointments", style: TextStyle(color: Colors.grey)),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text("Schedule Appointment"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
