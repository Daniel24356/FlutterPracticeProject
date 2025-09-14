import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdoptionListingsPage extends StatefulWidget {
  const AdoptionListingsPage({super.key});

  @override
  State<AdoptionListingsPage> createState() => _AdoptionListingsPageState();
}

class _AdoptionListingsPageState extends State<AdoptionListingsPage> {
  String searchQuery = "";
  String? selectedCategory;

  final List<Map<String, dynamic>> animals = [
    {
      "name": "Luna",
      "breed": "Persian",
      "age": "1 year",
      "gender": "Female",
      "health": "Healthy",
      "location": "Lagos, NG",
      "distance": "5km",
      "donation": "\$50.00",
      "imageUrl": "images/cat.png",
      "category": "Cat",
      "status": "Available",
      "description": "Luna is a calm and affectionate cat.",
    },
    {
      "name": "Max",
      "breed": "Labrador",
      "age": "2 years",
      "gender": "Male",
      "health": "Healthy",
      "location": "Abuja, NG",
      "distance": "10km",
      "donation": "\$75.00",
      "imageUrl": "images/dog.png",
      "category": "Dog",
      "status": "Available",
      "description": "Max is an energetic and loyal dog.",
    },
    {
      "name": "Nemo",
      "breed": "Goldfish",
      "age": "6 months",
      "gender": "Unknown",
      "health": "Healthy",
      "location": "Port Harcourt, NG",
      "distance": "15km",
      "donation": "\$20.00",
      "imageUrl": "images/fish.png",
      "category": "Fish",
      "status": "Available",
      "description": "Nemo is a vibrant and low-maintenance fish.",
    },
    {
      "name": "Tweety",
      "breed": "Canary",
      "age": "1 year",
      "gender": "Female",
      "health": "Healthy",
      "location": "Enugu, NG",
      "distance": "8km",
      "donation": "\$30.00",
      "imageUrl": "images/bird.png",
      "category": "Bird",
      "status": "Available",
      "description": "Tweety loves to sing and is very social.",
    },
    {
      "name": "Bunny",
      "breed": "Lop",
      "age": "1 year",
      "gender": "Male",
      "health": "Healthy",
      "location": "Kano, NG",
      "distance": "12km",
      "donation": "\$40.00",
      "imageUrl": "images/rabbit.png",
      "category": "Rabbit",
      "status": "Available",
      "description": "Bunny is playful and loves carrots.",
    },
  ];

  List<Map<String, dynamic>> get filteredAnimals => animals.where((animal) {
    final matchesSearch = animal["name"].toString().toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = selectedCategory == null || animal["category"] == selectedCategory;
    return matchesSearch && matchesCategory;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adoption Listings"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategory("images/cat.png", "Cat", Colors.green.shade100),
                  _buildCategory("images/dog.png", "Dog", Colors.blue.shade100),
                  _buildCategory("images/fish.png", "Fish", Colors.orange.shade100),
                  _buildCategory("images/bird.png", "Bird", Colors.purple.shade100),
                  _buildCategory("images/rabbit.png", "Rabbit", Colors.yellow.shade100),
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
                  final isSelected = selectedCategory == animal["category"];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailPage(animal: animal),
                        ),
                      );
                    },
                    child: Card(
                      elevation: isSelected ? 6 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isSelected ? const BorderSide(color: Colors.green, width: 3) : BorderSide.none,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              animal["imageUrl"],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  animal["name"],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  animal["donation"],
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  animal["distance"],
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
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

  Widget _buildCategory(String imagePath, String title, Color color) {
    final isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = isSelected ? null : title),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              color: isSelected ? Colors.white : null,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetDetailPage extends StatefulWidget {
  final Map<String, dynamic> animal;

  const PetDetailPage({super.key, required this.animal});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Simulate request submission
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adoption request submitted!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.orange,
        title: Text(widget.animal["name"]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                widget.animal["imageUrl"],
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.animal["name"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Donation: ${widget.animal["donation"]}",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                Text(
                  "Distance: ${widget.animal["distance"]}",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Breed", widget.animal["breed"].toString()),
            _buildDetailRow("Age", widget.animal["age"].toString()),
            _buildDetailRow("Gender", widget.animal["gender"].toString()),
            _buildDetailRow("Health", widget.animal["health"].toString()),
            _buildDetailRow("Location", widget.animal["location"].toString()),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              widget.animal["description"],
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              "Availability",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                widget.animal["status"],
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              backgroundColor: widget.animal["status"] == "Available" ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 20),
            if (widget.animal["status"] == "Available") ...[
              const Text(
                "Place Adoption Request",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: "Message (optional)",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Submit Request",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}