import 'package:flutter/material.dart';

class PetStorePage extends StatefulWidget {
  const PetStorePage({super.key});

  @override
  State<PetStorePage> createState() => _PetStorePageState();
}

class _PetStorePageState extends State<PetStorePage> {
  // Sample product list
  final List<Map<String, dynamic>> products = [
    {"name": "Cat Food", "image": "https://cdn.onemars.net/sites/whiskas_my_rRNUA_mwh5/image/mockup_wks_pouch_ad_tuna_new-look_-80g_f_1705068714309_1705677823811.png", "isFav": false},
    {"name": "Cat Bed", "image": "https://via.placeholder.com/150", "isFav": false},
    {"name": "Cat Toy", "image": "https://via.placeholder.com/150", "isFav": false},
  ];

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF0DB14C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('images/avatar.jpeg')
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Hi, Good Morning!",
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text("Evelyn Parker",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  const Icon(Icons.notifications_none, size: 28)
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search pet accessories...",
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),



              // Category
              const Text("Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategory(Icons.pets, "Cat", Colors.green.shade100),
                  _buildCategory(Icons.pets, "Dog", Colors.blue.shade100),
                  _buildCategory(Icons.pets, "Fish", Colors.orange.shade100),
                  _buildCategory(Icons.pets, "Bird", Colors.purple.shade100),
                ],
              ),
              const SizedBox(height: 20),

              // Popular Product
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Popular Product",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See All",
                      style: TextStyle(color: greenColor, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),

              // Horizontal Tags
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTag("All", true),
                    _buildTag("Cat Food", false),
                    _buildTag("Cat Treats", false),
                    _buildTag("Accessories", false),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Products Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(IconData icon, String title, Color bgColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: bgColor,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(title),
      ],
    );
  }

  Widget _buildTag(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0DB14C) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        product["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(product["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  )
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setLocalState(() {
                      product["isFav"] = !product["isFav"];
                    });
                  },
                  child: AnimatedScale(
                    scale: product["isFav"] ? 1.3 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Icon(
                      product["isFav"] ? Icons.favorite : Icons.favorite_border,
                      color: product["isFav"] ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
