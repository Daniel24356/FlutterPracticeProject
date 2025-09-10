import 'package:flutter/material.dart';

class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  static const Color primaryColor = Color(0xFF0DB14C);

  @override
  Widget build(BuildContext context) {
    // Mock data (design-only)
    final pets = [
      {'id': '1', 'name': 'Max', 'emoji': '🐕'},
      {'id': '2', 'name': 'Luna', 'emoji': '🐱'},
      {'id': '3', 'name': 'Coco', 'emoji': '🐰'},
    ];

    final vaccinations = [
      {
        'id': '1',
        'petId': '1',
        'petName': 'Max',
        'petEmoji': '🐕',
        'vaccine': 'Rabies',
        'date': '2024-01-15',
        'nextDue': '2025-01-15',
        'veterinarian': 'Dr. Smith',
        'batchNumber': 'RB2024-001',
        'status': 'current'
      },
      {
        'id': '2',
        'petId': '1',
        'petName': 'Max',
        'petEmoji': '🐕',
        'vaccine': 'DHPP',
        'date': '2024-02-10',
        'nextDue': '2025-02-10',
        'veterinarian': 'Dr. Smith',
        'batchNumber': 'DH2024-002',
        'status': 'current'
      },
      {
        'id': '3',
        'petId': '2',
        'petName': 'Luna',
        'petEmoji': '🐱',
        'vaccine': 'FVRCP',
        'date': '2023-12-05',
        'nextDue': '2024-12-05',
        'veterinarian': 'Dr. Johnson',
        'batchNumber': 'FV2023-045',
        'status': 'due_soon'
      },
    ];

    final medicalRecords = [
      {
        'id': '1',
        'petId': '1',
        'petName': 'Max',
        'petEmoji': '🐕',
        'date': '2024-08-15',
        'type': 'General Checkup',
        'veterinarian': 'Dr. Smith',
        'diagnosis': 'Healthy',
        'treatment': 'Routine examination',
        'notes': 'Overall health excellent. Weight stable.',
        'followUp': 'Annual checkup in 2025'
      },
      {
        'id': '2',
        'petId': '2',
        'petName': 'Luna',
        'petEmoji': '🐱',
        'date': '2024-07-20',
        'type': 'Dental Cleaning',
        'veterinarian': 'Dr. Brown',
        'diagnosis': 'Dental tartar buildup',
        'treatment': 'Professional dental cleaning under anesthesia',
        'notes': 'Tartar removed successfully. Teeth in good condition post-cleaning.',
        'followUp': 'Dental checkup in 6 months'
      },
    ];

    final medications = [
      {
        'id': '1',
        'petId': '1',
        'petName': 'Max',
        'petEmoji': '🐕',
        'medication': 'Heartgard Plus',
        'type': 'Heartworm Prevention',
        'dosage': '25mg monthly',
        'startDate': '2024-03-01',
        'endDate': '2025-03-01',
        'prescribedBy': 'Dr. Smith',
        'instructions': 'Give one chewable tablet monthly with food',
        'status': 'active'
      },
      {
        'id': '2',
        'petId': '3',
        'petName': 'Coco',
        'petEmoji': '🐰',
        'medication': 'Metacam',
        'type': 'Pain Relief',
        'dosage': '0.5ml daily',
        'startDate': '2024-08-01',
        'endDate': '2024-08-15',
        'prescribedBy': 'Dr. Johnson',
        'instructions': 'Give orally once daily for 2 weeks',
        'status': 'completed'
      },
    ];

    // Helper to map status -> chip color (design-only)
    Color statusColor(String status) {
      switch (status) {
        case 'current':
        case 'active':
          return Colors.grey.shade200;
        case 'due_soon':
          return Colors.red.shade100;
        case 'completed':
          return Colors.grey.shade300;
        case 'expired':
          return Colors.transparent;
        default:
          return Colors.grey.shade200;
      }
    }

    // Layout
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
            const Icon(Icons.article_outlined, color: Colors.black87),
            const SizedBox(width: 8),
            const Text('Health Records', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: const Text('Add Record', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              children: [
                // Filters row
                Row(
                  children: [
                    // Search field (flex)
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search, size: 18),
                            hintText: 'Search records...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Pet selector (design-only, value fixed to 'all')
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: 'all',
                        items: [
                          const DropdownMenuItem(value: 'all', child: Text('All Pets')),
                          ...pets.map((p) => DropdownMenuItem(value: p['id'] as String, child: Text("${p['emoji']} ${p['name']}"))),
                        ],
                        onChanged: (_) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Tabs
                DefaultTabController(
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
                            Tab(icon: Icon(Icons.shield_outlined), text: 'Vaccinations'),
                            Tab(icon: Icon(Icons.medical_information_outlined), text: 'Medical'),
                            Tab(icon: Icon(Icons.medication_outlined), text: 'Medications'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tab content area
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Vaccinations tab
                            _buildListArea(
                              context,
                              children: vaccinations.map((v) => _vaccinationCard(v, statusColor(v['status'] as String))).toList(),
                              emptyWidget: _emptyState(
                                icon: Icons.shield_outlined,
                                title: 'No Vaccination Records',
                                subtitle: "Add vaccination records to track your pet's immunization history.",
                              ),
                            ),

                            // Medical tab
                            _buildListArea(
                              context,
                              children: medicalRecords.map((r) => _medicalCard(r)).toList(),
                              emptyWidget: _emptyState(
                                icon: Icons.medical_information_outlined,
                                title: 'No Medical Records',
                                subtitle: 'Medical records from vet visits will appear here.',
                              ),
                            ),

                            // Medications tab
                            _buildListArea(
                              context,
                              children: medications.map((m) => _medicationCard(m, statusColor(m['status'] as String))).toList(),
                              emptyWidget: _emptyState(
                                icon: Icons.medication_outlined,
                                title: 'No Medication Records',
                                subtitle: "Track your pet's current and past medications here.",
                              ),
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
      ),
    );
  }

  // Reusable container for tab lists with padding & scroll
  static Widget _buildListArea(BuildContext context, {required List<Widget> children, required Widget emptyWidget}) {
    if (children.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Center(child: emptyWidget),
      );
    }

    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.only(top: 0, bottom: 12),
        children: children,
      ),
    );
  }

  // Vaccination card (matches React layout)
  static Widget _vaccinationCard(Map<String, dynamic> v, Color chipColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // top row: pet, title, badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Text(v['petEmoji'] ?? '', style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(v['vaccine'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(v['petName'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ]),
                  ],
                ),
                Chip(
                  label: Text((v['status'] == 'current') ? 'Up to Date' : 'Due Soon'),
                  backgroundColor: chipColor,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // details grid
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _detailBlock('Date Given', v['date'] ?? ''),
                _detailBlock('Next Due', v['nextDue'] ?? ''),
                _detailBlock('Veterinarian', v['veterinarian'] ?? ''),
                _detailBlock('Batch #', v['batchNumber'] ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Medical record card
  static Widget _medicalCard(Map<String, dynamic> r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text(r['petEmoji'] ?? '', style: const TextStyle(fontSize: 20))),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['type'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text("${r['petName']} • ${r['date']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ]),
            Text(r['veterinarian'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          if (r['diagnosis'] != null) ...[
            const Text('Diagnosis', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(r['diagnosis'] ?? ''),
            const SizedBox(height: 8),
          ],
          if (r['treatment'] != null) ...[
            const Text('Treatment', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(r['treatment'] ?? ''),
            const SizedBox(height: 8),
          ],
          if (r['notes'] != null) ...[
            const Text('Notes', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(r['notes'] ?? ''),
            const SizedBox(height: 8),
          ],
          if (r['followUp'] != null) ...[
            const Text('Follow-up', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(r['followUp'] ?? ''),
          ],
        ]),
      ),
    );
  }

  // Medication card
  static Widget _medicationCard(Map<String, dynamic> m, Color chipColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text(m['petEmoji'] ?? '', style: const TextStyle(fontSize: 20))),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m['medication'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text("${m['petName']} • ${m['type']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ]),
            Chip(label: Text((m['status'] as String).replaceFirst(m['status'][0], m['status'][0].toUpperCase())), backgroundColor: chipColor),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 8, children: [
            _detailBlock('Dosage', m['dosage'] ?? ''),
            _detailBlock('Duration', "${m['startDate']} - ${m['endDate']}"),
            _detailBlock('Prescribed By', m['prescribedBy'] ?? ''),
          ]),
          const SizedBox(height: 12),
          if (m['instructions'] != null)
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(),
              const Text('Instructions', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Text(m['instructions'] ?? '', style: const TextStyle(fontSize: 14)),
            ]),
        ]),
      ),
    );
  }

  // small key-value block used in cards
  static Widget _detailBlock(String title, String value) {
    return SizedBox(
      width: 240,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // empty state widget
  static Widget _emptyState({required IconData icon, required String title, required String subtitle}) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(icon, size: 48, color: Colors.grey.shade500),
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
    ]);
  }
}
