import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'UserProfile.dart';
import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';

void main() {
  runApp(const ShelterDashboard());
}

class ShelterDashboard extends StatelessWidget {
  const ShelterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawfectShelter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        primaryColor: Colors.orange,
        useMaterial3: true,
      ),
      home: const ShelterShell(),
    );
  }
}

// Shell that holds bottom navigation + drawer
class ShelterShell extends StatefulWidget {
  const ShelterShell({super.key});

  @override
  State<ShelterShell> createState() => _ShelterShellState();
}

class _ShelterShellState extends State<ShelterShell> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;
  late final AnimationController _fabController;

  final List<Widget> _pages = [
    const ShelterIndexPage(),
    const PetListingsPage(),
    const AdoptionRequestsPage(),
    const SuccessStoriesPage(),
    const UserProfile(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onNavTap(int idx) {
    setState(() => _selectedIndex = idx);
    _pageController.animateToPage(idx, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    if (idx == 1 || idx == 3) { // FAB for adding in Listings and Stories
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  void _openRoute(Widget page) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, anim, secAnim) {
      return FadeTransition(opacity: anim, child: page);
    }, transitionDuration: const Duration(milliseconds: 300)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(controller: _pageController, physics: const BouncingScrollPhysics(), children: _pages, onPageChanged: (i) => setState(() => _selectedIndex = i)),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (_selectedIndex == 1) {
              _openRoute(const AddAnimalPage());
            } else if (_selectedIndex == 3) {
              _openRoute(const AddStoryPage());
            }
          },
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Listings'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, backgroundColor: Colors.white, child: const Icon(Icons.pets, color: Colors.orange, size: 28)),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Hello, Shelter Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                ],
              ),
            ),
            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext c, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      horizontalTitleGap: 4,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

// ---------------------- Shelter Pages ----------------------

class ShelterIndexPage extends StatelessWidget {
  const ShelterIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "PawfectShelter",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('images/avatar3.jpeg'), // Assume asset
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Shelter Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _SectionHeader(title: "Today's Adoption Requests", actionLabel: 'View all', onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdoptionRequestsPage()))),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 170,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.86),
                      children: [
                        _RequestMiniCard(
                          petName: 'Max',
                          species: 'Dog',
                          applicant: 'Evelyn Parker',
                          dateTime: DateTime(2025, 9, 14, 10, 0),
                          imageUrl: 'images/maltese.png',
                        ),
                        _RequestMiniCard(
                          petName: 'Luna',
                          species: 'Cat',
                          applicant: 'Jane Smith',
                          dateTime: DateTime(2025, 9, 14, 12, 30),
                          imageUrl: 'images/luna.jpg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(title: "Shelter Stats", actionLabel: 'View details', onPressed: () {}),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatCard(title: 'Available Animals', value: '45', icon: Icons.pets),
                      _StatCard(title: 'Pending Requests', value: '12', icon: Icons.assignment),
                      _StatCard(title: 'Adoptions This Month', value: '8', icon: Icons.star),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 32),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _RequestMiniCard extends StatelessWidget {
  final String petName;
  final String species;
  final String applicant;
  final DateTime dateTime;
  final String imageUrl;

  const _RequestMiniCard({
    required this.petName,
    required this.species,
    required this.applicant,
    required this.dateTime,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(imageUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    species,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 14),
          Text('Applicant: $applicant'),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_today,
                    size: 16, color: Colors.orange),
              ),
              const SizedBox(width: 6),
              Text(
                DateFormat("d MMM").format(dateTime),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time,
                    size: 16, color: Colors.green),
              ),
              const SizedBox(width: 6),
              Text(
                DateFormat.jm().format(dateTime),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onPressed;
  const _SectionHeader({required this.title, required this.actionLabel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), TextButton(onPressed: onPressed, child: Text(actionLabel))]);
  }
}

// Pet Listings Page
class PetListingsPage extends StatefulWidget {
  const PetListingsPage({super.key});

  @override
  State<PetListingsPage> createState() => _PetListingsPageState();
}

class _PetListingsPageState extends State<PetListingsPage> {
  String searchQuery = "";
  String selectedCategory = "";

  final List<Map<String, dynamic>> animals = [
    {
      "name": "Max",
      "breed": "Maltese",
      "age": "2 years",
      "gender": "Male",
      "health": "Fit",
      "location": "Zurich, CH",
      "distance": "2km",
      "donation": "\$100",
      "imageUrl": "images/maltese.png",
      "category": "Dogs",
      "status": "Available",
      "description": "Max is playful and friendly.",
    },
    {
      "name": "Luna",
      "breed": "Manx",
      "age": "4 months",
      "gender": "Female",
      "health": "Fit",
      "location": "Kastanienallee, Berlin",
      "distance": "23km",
      "donation": "\$53",
      "imageUrl": "images/luna.jpg",
      "category": "Cats",
      "status": "Available",
      "description": "Luna is lovely and well trained. She loves to pull a little bit when she sees other dogs.",
    },
    // Add more hardcoded animals
    {
      "name": "Dash",
      "breed": "Giant Flemming",
      "age": "1 year",
      "gender": "Male",
      "health": "Fit",
      "location": "Zurich, CH",
      "distance": "5km",
      "donation": "\$15",
      "imageUrl": "images/dash.jpg",
      "category": "Rabbits",
      "status": "Available",
      "description": "Dash is energetic and curious.",
    },
  ];

  List<Map<String, dynamic>> get filteredAnimals => animals.where((animal) {
    final matchesSearch = animal["name"].toString().toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = selectedCategory == "All" || animal["category"] == selectedCategory;
    return matchesSearch && matchesCategory;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Animal Listings",
        showMenu: true,
        actionIcon: Icons.notifications_outlined,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search pets...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategory("Dogs", Colors.purple),
                  _buildCategory("Cats", Colors.grey.shade300),
                  _buildCategory("Birds", Colors.grey.shade300),
                  // Add more categories as needed
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredAnimals.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final animal = filteredAnimals[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimalDetailPage(animal: animal),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(animal["imageUrl"], fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(animal["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(animal["donation"]),
                                Text("${animal["distance"]}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String title, Color color) {
    final isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Animal Detail Page
class AnimalDetailPage extends StatefulWidget {
  final Map<String, dynamic> animal;

  const AnimalDetailPage({super.key, required this.animal});

  @override
  State<AnimalDetailPage> createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<AnimalDetailPage> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController healthController;
  late TextEditingController locationController;
  late TextEditingController donationController;
  late TextEditingController descriptionController;
  late String status;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.animal["name"]);
    breedController = TextEditingController(text: widget.animal["breed"]);
    ageController = TextEditingController(text: widget.animal["age"]);
    genderController = TextEditingController(text: widget.animal["gender"]);
    healthController = TextEditingController(text: widget.animal["health"]);
    locationController = TextEditingController(text: widget.animal["location"]);
    donationController = TextEditingController(text: widget.animal["donation"]);
    descriptionController = TextEditingController(text: widget.animal["description"]);
    status = widget.animal["status"];
  }

  void _saveChanges() {
    // Update animal data (in real app, save to db)
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changes saved!')));
  }

  void _deleteListing() {
    // Remove listing (in real app, delete from db)
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing deleted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          if (!isEditing) IconButton(icon: const Icon(Icons.edit), onPressed: () => setState(() => isEditing = true)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.animal["imageUrl"], fit: BoxFit.cover, height: 300, width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isEditing
                      ? TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name"))
                      : Text(widget.animal["name"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isEditing
                          ? TextField(controller: donationController, decoration: const InputDecoration(labelText: "Donation"))
                          : Text(widget.animal["donation"]),
                      Text(widget.animal["distance"]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     _infoItem("Breed", isEditing ? breedController : Text(widget.animal["breed"].toString())),
                  //     _infoItem("Age", isEditing ? ageController : Text(widget.animal["age"].toString())),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     _infoItem("Health", isEditing ? healthController : Text(widget.animal["health"].toString())),
                  //     _infoItem("Gender", isEditing ? genderController : Text(widget.animal["gender"].toString())),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  // _infoItem("Location", isEditing ? locationController : Text(widget.animal["location"].toString())),
                  const SizedBox(height: 16),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  isEditing
                      ? TextField(controller: descriptionController, maxLines: 5)
                      : Text(widget.animal["description"]),
                  const SizedBox(height: 16),
                  const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: status,
                    items: const [
                      DropdownMenuItem(value: "Available", child: Text("Available")),
                      DropdownMenuItem(value: "Adopted", child: Text("Adopted")),
                    ],
                    onChanged: isEditing ? (val) => setState(() => status = val!) : null,
                  ),
                  const SizedBox(height: 24),
                  if (isEditing) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Save'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => isEditing = false),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _deleteListing,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete Listing'),
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () {
                        // View requests for this pet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdoptionRequestsPage(petName: widget.animal["name"]),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('View Requests'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        value,
      ],
    );
  }
}

// Add Animal Page
class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({super.key});

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String category = "Dogs";
  String breed = "";
  String age = "";
  String gender = "";
  String health = "";
  String location = "";
  String donation = "";
  String description = "";
  String status = "Available";
  File? photo;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Add to listings (in real app, save to db)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Animal added!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Animal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Name *"),
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => name = val!,
              ),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: "Category *"),
                items: const [
                  DropdownMenuItem(value: "Dogs", child: Text("Dogs")),
                  DropdownMenuItem(value: "Cats", child: Text("Cats")),
                  DropdownMenuItem(value: "Birds", child: Text("Birds")),
                ],
                onChanged: (val) => setState(() => category = val!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Breed"),
                onSaved: (val) => breed = val ?? "",
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Age *"),
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => age = val!,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Gender *"),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                onChanged: (val) => gender = val!,
                validator: (val) => val == null ? "Required" : null,
                onSaved: (val) => gender = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Health Status *"),
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => health = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Location *"),
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => location = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Suggested Donation"),
                onSaved: (val) => donation = val ?? "",
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: photo == null ? const Center(child: Text("Upload Photo")) : Image.file(photo!),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 5,
                onSaved: (val) => description = val ?? "",
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: "Adoption Status"),
                items: const [
                  DropdownMenuItem(value: "Available", child: Text("Available")),
                  DropdownMenuItem(value: "Adopted", child: Text("Adopted")),
                ],
                onChanged: (val) => setState(() => status = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Add Animal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Adoption Requests Page
class AdoptionRequestsPage extends StatefulWidget {
  final String? petName; // Optional filter by pet

  const AdoptionRequestsPage({super.key, this.petName});

  @override
  State<AdoptionRequestsPage> createState() => _AdoptionRequestsPageState();
}

class _AdoptionRequestsPageState extends State<AdoptionRequestsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> requests = [
    {
      "id": "1",
      "petName": "Max",
      "applicant": {"name": "John Doe", "email": "john@example.com", "phone": "+123456789", "address": "123 Street"},
      "date": "2025-09-14",
      "status": "Pending",
    },
    {
      "id": "2",
      "petName": "Luna",
      "applicant": {"name": "Jane Smith", "email": "jane@example.com", "phone": "+987654321", "address": "456 Avenue"},
      "date": "2025-09-13",
      "status": "Approved",
    },
    // Add more
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Map<String, dynamic>> filteredRequests(String status) {
    return requests.where((req) {
      final matchesPet = widget.petName == null || req["petName"] == widget.petName;
      final matchesStatus = req["status"] == status || status == "All";
      return matchesPet && matchesStatus;
    }).toList();
  }

  void _approveRequest(String id) {
    // Update status
    setState(() {
      final req = requests.firstWhere((r) => r["id"] == id);
      req["status"] = "Approved";
    });
    // Send notification (mock)
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request approved! Notification sent.')));
  }

  void _rejectRequest(String id) {
    // Update status
    setState(() {
      final req = requests.firstWhere((r) => r["id"] == id);
      req["status"] = "Rejected";
    });
    // Send notification (mock)
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected! Notification sent.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption Requests')),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "Approved"),
              Tab(text: "Rejected"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestList("Pending"),
                _buildRequestList("Approved"),
                _buildRequestList("Rejected"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(String status) {
    final filtered = filteredRequests(status);
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final req = filtered[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pet: ${req["petName"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Applicant: ${req["applicant"]["name"]}"),
                Text("Email: ${req["applicant"]["email"]}"),
                Text("Phone: ${req["applicant"]["phone"]}"),
                Text("Address: ${req["applicant"]["address"]}"),
                Text("Date: ${req["date"]}"),
                if (status == "Pending") ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _approveRequest(req["id"]),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Approve'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _rejectRequest(req["id"]),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Reject'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// Success Stories Page
class SuccessStoriesPage extends StatefulWidget {
  const SuccessStoriesPage({super.key});

  @override
  State<SuccessStoriesPage> createState() => _SuccessStoriesPageState();
}

class _SuccessStoriesPageState extends State<SuccessStoriesPage> {
  final List<Map<String, dynamic>> stories = [
    {
      "petName": "Max",
      "adopterName": "John Doe",
      "date": "2025-08-01",
      "description": "Max found a loving home with John!",
      "photo": "images/maltese.png",
    },
    // Add more
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Success Stories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(story["photo"], fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story["petName"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Adopted by ${story["adopterName"]}"),
                      Text(story["date"]),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Add Story Page
class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  String petName = "";
  String adopterName = "";
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String description = "";
  File? photo;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Add to stories (in real app, save to db)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Story added!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Success Story')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Pet Name *"),
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => petName = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Adopter Name *"),
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => adopterName = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Adoption Date *"),
                initialValue: date,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => date = DateFormat('yyyy-MM-dd').format(picked));
                  }
                },
                readOnly: true,
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => date = val!,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: photo == null ? const Center(child: Text("Upload Photo")) : Image.file(photo!),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description *"),
                maxLines: 5,
                validator: (val) => val!.isEmpty ? "Required" : null,
                onSaved: (val) => description = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Add Story'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Contact and Volunteer Page
class ContactVolunteerPage extends StatefulWidget {
  const ContactVolunteerPage({super.key});

  @override
  State<ContactVolunteerPage> createState() => _ContactVolunteerPageState();
}

class _ContactVolunteerPageState extends State<ContactVolunteerPage> {
  final _contactKey = GlobalKey<FormState>();
  final _volunteerKey = GlobalKey<FormState>();
  final _donationKey = GlobalKey<FormState>();

  final Map<String, dynamic> contactData = {
    "name": "",
    "email": "",
    "message": "",
  };

  final Map<String, dynamic> volunteerData = {
    "name": "",
    "email": "",
    "phone": "",
    "availability": "",
  };

  final Map<String, dynamic> donationData = {
    "name": "",
    "email": "",
    "amount": "",
    "method": "Credit Card",
  };

  void _submitContact() {
    if (_contactKey.currentState!.validate()) {
      _contactKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message sent!")));
    }
  }

  void _submitVolunteer() {
    if (_volunteerKey.currentState!.validate()) {
      _volunteerKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Volunteer sign-up processed!")));
    }
  }

  void _submitDonation() {
    if (_donationKey.currentState!.validate()) {
      _donationKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Donation intent processed!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact & Volunteer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Contact Form", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Form(
              key: _contactKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Name *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => contactData["name"] = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => contactData["email"] = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Message *"),
                    maxLines: 5,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => contactData["message"] = val!,
                  ),
                  ElevatedButton(
                    onPressed: _submitContact,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Send Message'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Volunteer Sign-up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Form(
              key: _volunteerKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Name *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => volunteerData["name"] = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => volunteerData["email"] = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Phone"),
                    onSaved: (val) => volunteerData["phone"] = val ?? "",
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Availability *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => volunteerData["availability"] = val!,
                  ),
                  ElevatedButton(
                    onPressed: _submitVolunteer,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Donation Intent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Form(
              key: _donationKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Name *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => donationData["name"] = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => donationData["email"] = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Amount *"),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                    onSaved: (val) => donationData["amount"] = val!,
                  ),
                  DropdownButtonFormField<String>(
                    value: donationData["method"],
                    decoration: const InputDecoration(labelText: "Payment Method"),
                    items: const [
                      DropdownMenuItem(value: "Credit Card", child: Text("Credit Card")),
                      DropdownMenuItem(value: "PayPal", child: Text("PayPal")),
                      DropdownMenuItem(value: "Bank Transfer", child: Text("Bank Transfer")),
                    ],
                    onChanged: (val) => setState(() => donationData["method"] = val!),
                  ),
                  ElevatedButton(
                    onPressed: _submitDonation,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Submit Donation Intent'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for other pages like UserProfile, Login, etc. from template

// Assume components/AppSidebar.dart and components/CustomAppBar.dart are defined as in template or similar.