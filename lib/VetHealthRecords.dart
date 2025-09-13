import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For file uploads, add to pubspec.yaml: image_picker: ^1.0.4

void main() {
  runApp(VetHealthRecords());
}

class VetHealthRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Health Records',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Assuming a standard font
      ),
      home: PetsListPage(),
    );
  }
}

// Sample data model
class Pet {
  final String id;
  final String name;
  final String species; // e.g., 'Dog'
  final String breed; // e.g., 'English Bulldog'
  final String category; // e.g., 'Mammal' or whatever category
  final String ownerName;
  final String ownerImageUrl; // Placeholder
  final String petImageUrl; // Placeholder

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.category,
    required this.ownerName,
    required this.ownerImageUrl,
    required this.petImageUrl,
  });
}

// First Page: Pets List with Filtering
class PetsListPage extends StatefulWidget {
  @override
  _PetsListPageState createState() => _PetsListPageState();
}

class _PetsListPageState extends State<PetsListPage> {
  List<Pet> allPets = [
    Pet(
      id: '1',
      name: 'Tom',
      species: 'Dog',
      breed: 'English Bulldog',
      category: 'Mammal',
      ownerName: 'John Doe',
      ownerImageUrl: 'https://via.placeholder.com/50?text=Owner1', // Replace with actual
      petImageUrl: 'https://via.placeholder.com/80?text=Tom',
    ),
    Pet(
      id: '2',
      name: 'Bella',
      species: 'Cat',
      breed: 'Siamese',
      category: 'Mammal',
      ownerName: 'Jane Smith',
      ownerImageUrl: 'https://via.placeholder.com/50?text=Owner2',
      petImageUrl: 'https://via.placeholder.com/80?text=Bella',
    ),
    // Add more sample pets as needed
  ];

  List<Pet> filteredPets = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPets = allPets;
    _searchController.addListener(_filterPets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPets = allPets.where((pet) =>
      pet.name.toLowerCase().contains(query) ||
          pet.species.toLowerCase().contains(query) ||
          pet.breed.toLowerCase().contains(query) ||
          pet.category.toLowerCase().contains(query) ||
          pet.ownerName.toLowerCase().contains(query)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Pets'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Filter by name, category, species, or owner...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPets.length,
              itemBuilder: (context, index) {
                final pet = filteredPets[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthCardPage(pet: pet),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Column 1: Pet's name
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // Column 2: Species category and breed
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${pet.species} - ${pet.breed}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Category: ${pet.category}',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Column 3: Owner image and name
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(pet.ownerImageUrl),
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    pet.ownerName,
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Second Page: Health Card - Replicating the image design perfectly, with modifications for requirements
class HealthCardPage extends StatefulWidget {
  final Pet pet;

  const HealthCardPage({Key? key, required this.pet}) : super(key: key);

  @override
  _HealthCardPageState createState() => _HealthCardPageState();
}

class _HealthCardPageState extends State<HealthCardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 2; // Start with Medications as in image (orange)

  // Sample data for medications, etc. In real app, fetch from DB
  List<Map<String, dynamic>> medications = [
    {
      'name': 'Ketamine 100mg/cc',
      'dosage': '100mg/cc',
      'quantity': '45 ml',
      'doctor': 'Dr. Jenny Wilson',
      'hospital': 'Animal Hospital',
      'status': 'Active',
      'refillsLeft': 1,
      'totalRefills': 5,
      'created': '11/12/2025',
      'expires': '28/12/2025',
      'doctorImage': 'https://via.placeholder.com/40?text=Doc', // Placeholder
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = _selectedTabIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to add diagnosis/treatment notes (modal)
  void _addDiagnosisOrNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Diagnosis/Treatment Notes'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter details...'),
          maxLines: 5,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () {
            // Save to DB, etc.
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved!')));
          }, child: Text('Save')),
        ],
      ),
    );
  }

  // Function to add prescription (similar modal)
  void _addPrescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Prescription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Medication Name')),
            TextField(decoration: InputDecoration(labelText: 'Dosage')),
            TextField(decoration: InputDecoration(labelText: 'Quantity')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () {
            // Save
            Navigator.pop(context);
            setState(() {}); // Refresh list
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Prescription added!')));
          }, child: Text('Add')),
        ],
      ),
    );
  }

  // Function to upload files/images
  Future<void> _uploadFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload to storage, save URL to DB
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded: ${pickedFile.name}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hardcoded pet details to match image; in real app, fetch dynamically
    final gender = 'Female';
    final age = '6 years';
    final passportId = 'Gold, White';
    final marks = 'One blue eye';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Health card',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile section
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.pet.petImageUrl),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.pet.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Edit pet details modal
                                _showEditPetModal();
                              },
                              child: Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.pet.breed,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Gender and Age row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Gender', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Spacer(),
                        Text(gender, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.orange[300]),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.green[300]),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Age', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Spacer(),
                        Text(age, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.green[300]),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.green[300]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Passport ID and Distinctive marks row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Passport ID', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Spacer(),
                        Text(passportId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.blue[300]),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.purple[300]),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Distinctive marks', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Spacer(),
                        Text(marks, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.purple[300]),
                        SizedBox(width: 8),
                        Icon(Icons.pets, size: 16, color: Colors.purple[300]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Tab buttons: Overview, Preventive, Medications
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTabButton('Overview', 0, Icons.description_outlined),
                  SizedBox(width: 16),
                  _buildTabButton('Preventive', 1, Icons.health_and_safety_outlined),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTabButton('Medications', 2, Icons.medication, isSelected: true),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Modifications for requirements: Access history, add notes/prescriptions, upload
            if (_selectedTabIndex == 0) // Overview: Medical history access
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medical History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3, // Sample
                      itemBuilder: (context, index) => ListTile(
                        title: Text('Visit ${index + 1}'),
                        subtitle: Text('Date: 2025-01-01'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Show history details
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing history...')));
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addDiagnosisOrNotes,
                      icon: Icon(Icons.add),
                      label: Text('Add Diagnosis/Treatment Notes'),
                    ),
                  ],
                ),
              )
            else if (_selectedTabIndex == 1) // Preventive
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text('Preventive Care', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    // Sample content
                    Card(child: ListTile(title: Text('Vaccination Schedule'))),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _uploadFile,
                      icon: Icon(Icons.upload),
                      label: Text('Upload X-rays/Reports'),
                    ),
                  ],
                ),
              )
            else if (_selectedTabIndex == 2) // Medications: Replicate image
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Dates row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Created: ${medications[0]['created']}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Expires: ${medications[0]['expires']}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Medication details
                      Card(
                        color: Colors.orange[50],
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${medications[0]['name']}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('${medications[0]['dosage']}'),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('${medications[0]['quantity']}'),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('Active', style: TextStyle(color: Colors.blue[800])),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Doctor info
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(medications[0]['doctorImage']),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medications[0]['doctor'],
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          medications[0]['hospital'],
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Refills
                              Row(
                                children: [
                                  Text('Refills left: ${medications[0]['refillsLeft']} out of ${medications[0]['totalRefills']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Add prescription and upload buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _addPrescription,
                              child: Text('Add Prescription'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _uploadFile,
                              icon: Icon(Icons.upload),
                              label: Text('Upload Files'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon, {bool isSelected = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          _tabController.animateTo(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.orange : Colors.grey),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPetModal() {
    // Simple edit modal, similar to add
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Pet Details'),
        content: TextField(decoration: InputDecoration(labelText: 'Update info...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Save')),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// // For file uploads, add 'image_picker' to your pubspec.yaml and import it.
// // import 'package:image_picker/image_picker.dart';
// // This code assumes basic setup; expand with state management (e.g., Provider, Riverpod) for real app.
//
// void main() {
//   runApp(const VetHealthRecords());
// }
//
// class VetHealthRecords extends StatelessWidget {
//   const VetHealthRecords({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Vet Health Records',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.purple,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ),
//       home: const PetListPage(),
//     );
//   }
// }
//
// class Pet {
//   final String name;
//   final String species;
//   final String breed;
//   final String gender;
//   final String age;
//   final String passportId;
//   final String distinctiveMarks;
//   final String ownerName;
//   final String ownerImageUrl;
//   final String petImageUrl;
//
//   // Additional fields for health records (hardcoded for demo)
//   final List<String> medicalHistory;
//   final List<Map<String, String>> prescriptions;
//
//   Pet({
//     required this.name,
//     required this.species,
//     required this.breed,
//     required this.gender,
//     required this.age,
//     required this.passportId,
//     required this.distinctiveMarks,
//     required this.ownerName,
//     required this.ownerImageUrl,
//     required this.petImageUrl,
//     this.medicalHistory = const [],
//     this.prescriptions = const [],
//   });
// }
//
// class PetListPage extends StatelessWidget {
//   const PetListPage({super.key});
//
//   // Hardcoded demo data for assigned pets
//   final List<Pet> assignedPets = [
//     Pet(
//       name: 'Tom',
//       species: 'Dog',
//       breed: 'English Bulldog',
//       gender: 'Female',
//       age: '6 years',
//       passportId: 'Gold, White',
//       distinctiveMarks: 'One blue eye',
//       ownerName: 'John Doe',
//       ownerImageUrl: 'https://example.com/owner.jpg',
//       petImageUrl: 'https://example.com/pet-tom.jpg',
//       medicalHistory: ['Routine checkup on 01/01/2025', 'Vaccination on 05/05/2025'],
//       prescriptions: [
//         {
//           'name': 'Ketamine 100mg/cc',
//           'amount': '45 ml',
//           'created': '11/12/2025',
//           'expires': '28/12/2025',
//           'doctor': 'Doctor Jenny Wilson',
//           'hospital': 'Animal Hospital',
//           'refillsLeft': '1 out of 5',
//           'status': 'Active',
//         },
//       ],
//     ),
//     Pet(
//       name: 'Bella',
//       species: 'Cat',
//       breed: 'Siamese',
//       gender: 'Female',
//       age: '4 years',
//       passportId: 'Blue, White',
//       distinctiveMarks: 'None',
//       ownerName: 'Jane Smith',
//       ownerImageUrl: 'https://example.com/owner2.jpg',
//       petImageUrl: 'https://example.com/pet-bella.jpg',
//       medicalHistory: ['Dental cleaning on 03/03/2025'],
//       prescriptions: [],
//     ),
//     // Add more pets as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Assigned Pets'),
//       ),
//       body: ListView.builder(
//         itemCount: assignedPets.length,
//         itemBuilder: (context, index) {
//           final pet = assignedPets[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PetDetailPage(pet: pet),
//                 ),
//               );
//             },
//             child: Card(
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // First column: Pet's name
//                     Expanded(
//                       child: Text(
//                         pet.name,
//                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     // Second column: Species and breed
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             pet.species,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           Text(
//                             pet.breed,
//                             style: const TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Third column: Owner's image and name
//                     Expanded(
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 20,
//                             backgroundImage: NetworkImage(pet.ownerImageUrl),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             pet.ownerName,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class PetDetailPage extends StatefulWidget {
//   final Pet pet;
//
//   const PetDetailPage({super.key, required this.pet});
//
//   @override
//   State<PetDetailPage> createState() => _PetDetailPageState();
// }
//
// class _PetDetailPageState extends State<PetDetailPage> {
//   // For demo; in real app, use state management to update data
//   late List<String> medicalHistory;
//   late List<Map<String, String>> prescriptions;
//   List<String> uploadedFiles = []; // Demo list for uploaded files
//
//   @override
//   void initState() {
//     super.initState();
//     medicalHistory = List.from(widget.pet.medicalHistory);
//     prescriptions = List.from(widget.pet.prescriptions);
//   }
//
//   void _addDiagnosis() {
//     // In real app, show dialog/form to add
//     setState(() {
//       medicalHistory.add('New diagnosis added on ${DateTime.now().toString().substring(0, 10)}');
//     });
//   }
//
//   void _addTreatmentNotes() {
//     // In real app, show dialog/form
//     setState(() {
//       medicalHistory.add('New treatment notes added on ${DateTime.now().toString().substring(0, 10)}');
//     });
//   }
//
//   void _addPrescription() {
//     // In real app, show dialog/form
//     setState(() {
//       prescriptions.add({
//         'name': 'New Prescription',
//         'amount': '10 ml',
//         'created': DateTime.now().toString().substring(0, 10),
//         'expires': DateTime.now().add(const Duration(days: 30)).toString().substring(0, 10),
//         'doctor': 'Current Vet',
//         'hospital': 'Vet Clinic',
//         'refillsLeft': '5 out of 5',
//         'status': 'Active',
//       });
//     });
//   }
//
//   void _uploadFile() async {
//     // Uncomment and add image_picker package for real functionality
//     // final picker = ImagePicker();
//     // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     // if (pickedFile != null) {
//     //   setState(() {
//     //     uploadedFiles.add(pickedFile.path);
//     //   });
//     // }
//     setState(() {
//       uploadedFiles.add('New file uploaded on ${DateTime.now().toString().substring(0, 10)}');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Health card'),
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundImage: NetworkImage(widget.pet.petImageUrl),
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.pet.name,
//                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       '${widget.pet.species} - ${widget.pet.breed}',
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Implement edit functionality (e.g., show form)
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                   ),
//                   child: const Text('Edit'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.purple[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.pets, color: Colors.purple),
//                       const SizedBox(width: 4),
//                       Text(widget.pet.gender),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.green[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.pets, color: Colors.green),
//                       const SizedBox(width: 4),
//                       Text(widget.pet.age),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.pets, color: Colors.blue),
//                       const SizedBox(width: 4),
//                       Text('Passport Id: ${widget.pet.passportId}'),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.purple[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.pets, color: Colors.purple),
//                       const SizedBox(width: 4),
//                       Text('Distinctive marks: ${widget.pet.distinctiveMarks}'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.description, size: 32),
//                       onPressed: () {}, // Overview tab action
//                     ),
//                     const Text('Overview'),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.health_and_safety, size: 32),
//                       onPressed: () {}, // Preventive tab action
//                     ),
//                     const Text('Preventive'),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.orange,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         icon: const Icon(Icons.vaccines, color: Colors.white, size: 32),
//                         onPressed: () {}, // Medications tab action
//                       ),
//                     ),
//                     const Text('Medications'),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             // Medications section (replicating the design)
//             ...prescriptions.map((prescription) => Card(
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Created: ${prescription['created']}'),
//                         Text('Expires: ${prescription['expires']}'),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       prescription['name'] ?? '',
//                       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     Text(prescription['amount'] ?? ''),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           // Use actual doctor image if available
//                           backgroundImage: NetworkImage('https://example.com/doctor.jpg'),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(prescription['doctor'] ?? ''),
//                             Text(prescription['hospital'] ?? ''),
//                           ],
//                         ),
//                         const Spacer(),
//                         Chip(
//                           label: Text(prescription['status'] ?? ''),
//                           backgroundColor: Colors.green[200],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Implement refill logic
//                       },
//                       child: const Text('Refill medication'),
//                     ),
//                     const SizedBox(height: 8),
//                     Text('Refills left: ${prescription['refillsLeft']}'),
//                   ],
//                 ),
//               ),
//             )),
//             const SizedBox(height: 32),
//             // Additional requirements: Medical History
//             const Text(
//               'Medical History',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: medicalHistory.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(medicalHistory[index]),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _addDiagnosis,
//               child: const Text('Add Diagnosis'),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _addTreatmentNotes,
//               child: const Text('Add Treatment Notes'),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _addPrescription,
//               child: const Text('Add Prescription'),
//             ),
//             const SizedBox(height: 32),
//             // Upload files section
//             const Text(
//               'Uploaded Files (X-rays, Test Reports)',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: uploadedFiles.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(uploadedFiles[index]),
//                   leading: const Icon(Icons.image),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _uploadFile,
//               child: const Text('Upload File or Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
