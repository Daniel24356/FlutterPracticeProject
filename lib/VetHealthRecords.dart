import 'dart:ui';
import 'package:flutter/material.dart';

import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';

void main() {
  runApp(const VetHealthRecords());
}

class VetHealthRecords extends StatelessWidget {
  const VetHealthRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assigned Pets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const VetDashboardPage(),
    );
  }
}

class Pet {
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String weight;
  final String passportId;
  final String distinctiveMarks;
  final String ownerName;
  final String ownerImage;
  final String petImage;
  final List<Visit> visits;
  final List<Prescription> allPrescriptions;
  final List<String> uploadedFiles;

  Pet({
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.passportId,
    required this.distinctiveMarks,
    required this.ownerName,
    required this.ownerImage,
    required this.petImage,
    required this.visits,
    required this.allPrescriptions,
    this.uploadedFiles = const [],
  });
}

class Visit {
  final String type;
  final DateTime date;
  final List<Record> records;

  Visit({
    required this.type,
    required this.date,
    required this.records,
  });
}

class Record {
  final String title;
  final List<String> notes;
  final List<Prescription> prescriptions;

  Record({
    required this.title,
    required this.notes,
    required this.prescriptions,
  });
}

class Prescription {
  final DateTime date;
  final String name;
  final String notes; // why given and usage

  Prescription({
    required this.date,
    required this.name,
    required this.notes,
  });
}

class VetDashboardPage extends StatefulWidget {
  const VetDashboardPage({super.key});

  @override
  State<VetDashboardPage> createState() => _VetDashboardPageState();
}

class _VetDashboardPageState extends State<VetDashboardPage> {
  // Hardcoded demo data for assigned pets
  final List<Pet> assignedPets = [
    Pet(
      name: 'Max',
      species: 'Dog',
      breed: 'Maltese',
      gender: 'Male',
      age: '6 years',
      weight: '25 kg',
      passportId: 'Gold, White',
      distinctiveMarks: 'One blue eye',
      ownerName: 'Evelyn Parker',
      ownerImage: 'images/avatar.jpeg',
      petImage: 'images/maltese.png',
      visits: [
        Visit(
          type: 'General Checkup',
          date: DateTime(2025, 1, 1),
          records: [
            Record(
              title: 'Routine Examination',
              notes: [
                'Feeding concerns',
                'Possible anemia',
                'Dilated eyes',
              ],
              prescriptions: [
                Prescription(
                  date: DateTime(2025, 1, 1),
                  name: 'Multivitamin Supplement',
                  notes: 'Given for possible anemia; administer 1 tablet daily with food.',
                ),
              ],
            ),
            Record(
              title: 'Blood Test Results',
              notes: [
                'Low red blood cell count',
                'Recommend follow-up in 2 weeks',
              ],
              prescriptions: [],
            ),
          ],
        ),
        Visit(
          type: 'Surgery',
          date: DateTime(2025, 5, 5),
          records: [
            Record(
              title: 'Spay Procedure',
              notes: [
                'Successful surgery',
                'Post-op care instructions provided',
              ],
              prescriptions: [
                Prescription(
                  date: DateTime(2025, 5, 5),
                  name: 'Pain Relief Medication',
                  notes: 'Given for post-surgery pain; 5ml twice daily for 3 days.',
                ),
              ],
            ),
          ],
        ),
      ],
      allPrescriptions: [
        Prescription(
          date: DateTime(2025, 1, 1),
          name: 'Multivitamin Supplement',
          notes: 'Given for possible anemia; administer 1 tablet daily with food.',
        ),
        Prescription(
          date: DateTime(2025, 5, 5),
          name: 'Pain Relief Medication',
          notes: 'Given for post-surgery pain; 5ml twice daily for 3 days.',
        ),
        Prescription(
          date: DateTime(2025, 8, 15),
          name: 'Ketamine 100mg/cc',
          notes: 'Administered for sedation during procedure; 45ml total, refills available.',
        ),
      ],
      uploadedFiles: ['X-ray_2025-01-01.png', 'Blood_Test_2025-01-01.pdf'],
    ),
    Pet(
      name: 'Luna',
      species: 'Cat',
      breed: 'Manx',
      gender: 'Female',
      age: '4 years',
      weight: '5 kg',
      passportId: 'Blue, White',
      distinctiveMarks: 'None',
      ownerName: 'Jane Smith',
      ownerImage: 'images/avatar2.jpeg',
      petImage: 'images/luna.jpg',
      visits: [
        Visit(
          type: 'Dental Cleaning',
          date: DateTime(2025, 3, 3),
          records: [
            Record(
              title: 'Oral Examination',
              notes: [
                'Mild plaque buildup',
                'Teeth cleaned successfully',
              ],
              prescriptions: [
                Prescription(
                  date: DateTime(2025, 3, 3),
                  name: 'Antibiotic Ointment',
                  notes: 'Given for gum inflammation; apply twice daily.',
                ),
              ],
            ),
          ],
        ),
      ],
      allPrescriptions: [
        Prescription(
          date: DateTime(2025, 3, 3),
          name: 'Antibiotic Ointment',
          notes: 'Given for gum inflammation; apply twice daily.',
        ),
      ],
      uploadedFiles: ['Dental_X-ray_2025-03-03.png'],
    ),
    // Add more pets as needed
  ];

  String searchQuery = "";
  String selectedSpecies = "All";

  final TextEditingController _searchController = TextEditingController();

  List<Pet> get filteredPets => assignedPets.where((pet) {
    final matchesSearch = pet.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        pet.ownerName.toLowerCase().contains(searchQuery.toLowerCase());
    final matchesSpecies = selectedSpecies == "All" || pet.species == selectedSpecies;
    return matchesSearch && matchesSpecies;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Pet Records",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header

              const SizedBox(height: 20),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search pets or owners...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () {}, // Can add filters if needed
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),

              // Species Row
              const Text("Species",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpecies("images/cat.png", "Cat", Colors.green.shade100),
                  _buildSpecies("images/dog.png", "Dog", Colors.blue.shade100),
                  _buildSpecies(
                      "images/fish.png", "Fish", Colors.orange.shade100),
                  _buildSpecies(
                      "images/bird.png", "Bird", Colors.green.shade100),
                  _buildSpecies("images/rabbit.png", "Rabbit",
                      Colors.yellow.shade100),
                ],
              ),
              const SizedBox(height: 20),

              // Pets Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemBuilder: (context, index) {
                  final pet = filteredPets[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailPage(pet: pet),
                        ),
                      );
                    },
                    child: _buildPetCard(pet),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Species with selection border
  Widget _buildSpecies(String imagePath, String title, Color bgColor) {
    final isSelected = selectedSpecies == title;
    return GestureDetector(
      onTap: () => setState(() {
        if (selectedSpecies == title) {
          selectedSpecies = "All";
        } else {
          selectedSpecies = title;
        }
      }),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(color: const Color(0xFF0DB14C), width: 2)
                  : null,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: bgColor,
              backgroundImage: AssetImage(imagePath), // Use AssetImage for local assets
            ),
          ),
          const SizedBox(height: 6),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Pet Image
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                pet.petImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.pets,
                      color: Colors.grey, size: 40),
                ),
              ),
            ),

            // Blurred overlay with pet details and owner
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    color: Colors.black.withOpacity(0.3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pet.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              pet.species,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(pet.ownerImage),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pet.ownerName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}

class PetDetailPage extends StatefulWidget {
  final Pet pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  int selectedTab = 0; // 0: Overview, 1: Medications
  Visit? selectedVisit;
  String visitSearchQuery = "";
  String recordSearchQuery = "";
  String medicationSearchQuery = "";
  late List<String> uploadedFiles;

  @override
  void initState() {
    super.initState();
    uploadedFiles = List.from(widget.pet.uploadedFiles);
  }

  void _addRecord(Visit visit) {
    // Demo: Add a new record
    setState(() {
      visit.records.add(
        Record(
          title: 'New Record ${DateTime.now().toString().substring(0, 10)}',
          notes: ['New note 1', 'New note 2'],
          prescriptions: [],
        ),
      );
    });
  }

  void _addPrescription(Visit visit) {
    // Demo: Add to record or directly
    if (visit.records.isNotEmpty) {
      final newPres = Prescription(
        date: DateTime.now(),
        name: 'New Prescription',
        notes: 'New notes; usage instructions.',
      );
      setState(() {
        visit.records.last.prescriptions.add(newPres);
        widget.pet.allPrescriptions.add(newPres);
      });
    }
  }

  void _uploadFile() {
    // Demo
    setState(() {
      uploadedFiles.add('New_file_${DateTime.now().toString().substring(0, 10)}.png');
    });
  }

  List<Visit> get filteredVisits => widget.pet.visits.where((visit) {
    return visit.type.toLowerCase().contains(visitSearchQuery.toLowerCase()) ||
        visit.date.toString().contains(visitSearchQuery);
  }).toList();

  List<Record> filteredRecords(Visit visit) => visit.records.where((record) {
    return record.title.toLowerCase().contains(recordSearchQuery.toLowerCase());
  }).toList();

  List<Prescription> get filteredPrescriptions => widget.pet.allPrescriptions.where((pres) {
    return pres.name.toLowerCase().contains(medicationSearchQuery.toLowerCase()) ||
        pres.notes.toLowerCase().contains(medicationSearchQuery.toLowerCase());
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${widget.pet.name}'s Record ", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.pet.petImage),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pet.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.pet.species} - ${widget.pet.breed}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Edit pet details
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Gender', widget.pet.gender, Icons.transgender),
                _buildInfoCard('Age', widget.pet.age, Icons.cake),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Weight', widget.pet.weight, Icons.scale),
                _buildInfoCard('Marks', widget.pet.distinctiveMarks, Icons.star_border),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Overview Tab
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedTab == 0 ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description,
                              size: 28,
                              color: selectedTab == 0 ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 14,
                                color: selectedTab == 0 ? Colors.white : Colors.grey,
                                fontWeight:
                                selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Medications Tab
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selectedTab == 1 ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.vaccines,
                              size: 28,
                              color: selectedTab == 1 ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Medications',
                              style: TextStyle(
                                fontSize: 14,
                                color: selectedTab == 1 ? Colors.white : Colors.grey,
                                fontWeight:
                                selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            if (selectedTab == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Visits',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Edit pet details
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => setState(() => visitSearchQuery = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search visits...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedVisit == null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredVisits.length,
                  itemBuilder: (context, index) {
                    final visit = filteredVisits[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          visit.type,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(visit.date.toString().substring(0, 10)),
                        onTap: () => setState(() => selectedVisit = visit),
                      ),
                    );
                  },
                )
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedVisit!.type,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => setState(() => selectedVisit = null),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => setState(() => recordSearchQuery = value),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search records...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredRecords(selectedVisit!).length,
                  itemBuilder: (context, index) {
                    final record = filteredRecords(selectedVisit!)[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...record.notes.map((note) => Text('• $note')),
                            if (record.prescriptions.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Text('Prescriptions:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ...record.prescriptions.map((pres) => Text('- ${pres.name}: ${pres.notes}')),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _addRecord(selectedVisit!),
                  child: const Text('Add Record'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _addPrescription(selectedVisit!),
                  child: const Text('Add Prescription'),
                ),
              ],
              const SizedBox(height: 32),
              const Text(
                'Uploaded Files (X-rays, Test Reports)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: uploadedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(uploadedFiles[index]),
                    leading: const Icon(Icons.image),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadFile,
                child: const Text('Upload File or Image'),
              ),
            ] else if (selectedTab == 1) ...[
              const Text(
                'Medications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => setState(() => medicationSearchQuery = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search medications...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPrescriptions.length,
                itemBuilder: (context, index) {
                  final pres = filteredPrescriptions[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pres.date.toString().substring(0, 10)),
                          const SizedBox(height: 8),
                          Text(pres.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(pres.notes),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey)),
                Text(value),
              ],
            ),
          ],
        ),
      ),
    );
  }
}