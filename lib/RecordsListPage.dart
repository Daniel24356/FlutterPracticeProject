import 'package:flutter/material.dart';

class RecordsListPage extends StatefulWidget {
  final String category;
  const RecordsListPage({super.key, required this.category});

  @override
  State<RecordsListPage> createState() => _RecordsListPageState();
}

class _RecordsListPageState extends State<RecordsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // Dummy example records
  final List<Map<String, String>> records = [
    {
      "date": "2024-09-01",
      "title": "Knee Surgery",
      "details": "Procedure done at Downtown Vet Clinic.\nRecovery time: 6 weeks."
    },
    {
      "date": "2023-11-15",
      "title": "Dental Surgery",
      "details": "Teeth cleaning under anesthesia.\nDoctor: Dr. Brown."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = records
        .where((r) =>
    r["title"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
        r["details"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Your Search Bar
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Search ${widget.category.toLowerCase()}...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {},
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Timeline List
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final record = filtered[i];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline line + bullet
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle),
                          ),
                          if (i != filtered.length - 1)
                            Container(
                              width: 2,
                              height: 60,
                              color: Colors.green,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Record info
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
        ),
      ),
    );
  }
}
