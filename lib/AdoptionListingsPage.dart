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
  double minPrice = 0.0;
  double maxPrice = 100.0;

  final List<Map<String, dynamic>> animals = [
    {
      "name": "Luna",
      "breed": "Manx",
      "age": "1 year",
      "gender": "Female",
      "health": "Healthy",
      "location": "Lagos, NG",
      "distance": "5km",
      "donation": "\$50.00",
      "imageUrl": "images/luna.jpg",
      "category": "Cat",
      "status": "Available",
      "description": "Luna is a calm and affectionate cat.",
    },
    {
      "name": "Max",
      "breed": "Maltese",
      "age": "2 years",
      "gender": "Male",
      "health": "Healthy",
      "location": "Abuja, NG",
      "distance": "10km",
      "donation": "\$75.00",
      "imageUrl": "images/maltese.png",
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
      "imageUrl": "images/nemo.png",
      "category": "Fish",
      "status": "Available",
      "description": "Nemo is a vibrant and low-maintenance fish.",
    },
    {
      "name": "Tweety",
      "breed": "Parrot",
      "age": "1 year",
      "gender": "Female",
      "health": "Healthy",
      "location": "Enugu, NG",
      "distance": "8km",
      "donation": "\$30.00",
      "imageUrl": "images/tom.jpg",
      "category": "Bird",
      "status": "Available",
      "description": "Tweety loves to sing and is very social.",
    },
    {
      "name": "Dash",
      "breed": "Lop",
      "age": "1 year",
      "gender": "Male",
      "health": "Healthy",
      "location": "Kano, NG",
      "distance": "12km",
      "donation": "\$40.00",
      "imageUrl": "images/dash.jpg",
      "category": "Rabbit",
      "status": "Available",
      "description": "Bunny is playful and loves carrots.",
    },
  ];

  List<Map<String, dynamic>> get filteredAnimals => animals.where((animal) {
    final matchesSearch = animal["name"].toString().toLowerCase().contains(searchQuery.toLowerCase());
    final matchesCategory = selectedCategory == null || animal["category"] == selectedCategory;
    final donation = double.parse(animal["donation"].toString().replaceAll(RegExp(r'[^\d.]'), ''));
    final matchesPrice = donation >= minPrice && donation <= maxPrice;
    return matchesSearch && matchesCategory && matchesPrice;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text("Adoption Listings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () => _showPriceFilter(context),
                  ),
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
                  _buildCategory("images/fish.png", "Fish", Colors.green.shade100),
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
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  animal["name"],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  animal["donation"],
                                  style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),

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

  Widget _buildCategory(String image, String title, Color bgColor) {
    final isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = isSelected ? null : title),
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
              backgroundImage: AssetImage(image),
            ),
          ),
          const SizedBox(height: 6),
          Text(title),
        ],
      ),
    );
  }

  void _showPriceFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double tempMin = minPrice;
        double tempMax = maxPrice;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Filter by Price",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  RangeSlider(
                    values: RangeValues(tempMin, tempMax),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: const Color(0xFF0DB14C),
                    labels: RangeLabels(
                        "\$${tempMin.toStringAsFixed(0)}",
                        "\$${tempMax.toStringAsFixed(0)}"),
                    onChanged: (values) {
                      setModalState(() {
                        tempMin = values.start;
                        tempMax = values.end;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0DB14C)),
                    onPressed: () {
                      setState(() {
                        minPrice = tempMin;
                        maxPrice = tempMax;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Apply"),
                  )
                ],
              ),
            );
          },
        );
      },
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
        backgroundColor: Colors.green,
        title: Text(widget.animal["name"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.animal["name"],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${widget.animal["donation"]}",
                  style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.pets, "Breed", widget.animal["breed"].toString(), Colors.blue),
            _buildDetailRow(Icons.person, "Age", widget.animal["age"].toString(), Colors.orange),
            _buildDetailRow(Icons.wc, "Gender", widget.animal["gender"].toString(), Colors.purple),
            _buildDetailRow(Icons.local_hospital, "Health", widget.animal["health"].toString(), Colors.green),
            _buildDetailRow(Icons.location_on, "Location", widget.animal["location"].toString(), Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              widget.animal["description"],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            if (widget.animal["status"] == "Available") ...[
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.animal["status"],
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      decoration: InputDecoration(
                        labelText: "Message (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ],
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