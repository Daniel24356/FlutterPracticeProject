import 'dart:ui';
import 'package:flutter/material.dart';

import 'components/AppSidebar.dart';
import 'components/CustomAppBar.dart';

class PetStorePage extends StatefulWidget {
  const PetStorePage({super.key});

  @override
  State<PetStorePage> createState() => _PetStorePageState();
}

class _PetStorePageState extends State<PetStorePage> {
  // Sample product list
  final List<Map<String, dynamic>> products = [
    {
      "name": "Cat Food",
      "price": 31.2,
      "category": "Food & Treats",
      "pet": "Cat",
      "image":
      "https://cdn.onemars.net/sites/whiskas_my_rRNUA_mwh5/image/mockup_wks_pouch_ad_tuna_new-look_-80g_f_1705068714309_1705677823811.png",
      "isFav": false
    },
    {
      "name": "Cat Bed",
      "price": 25.5,
      "category": "Homes",
      "pet": "Cat",
      "image":
      "https://target.scene7.com/is/image/Target/GUEST_e272c047-b798-4a77-9daa-876b6166c941?wid=488&hei=488&fmt=pjpeg",
      "isFav": false
    },
    {
      "name": "Grooming Kit",
      "price": 15.8,
      "category": "Grooming",
      "pet": "Dog",
      "image": "https://m.media-amazon.com/images/I/61AdoOztqGL._SL1000_.jpg",
      "isFav": false
    },
    {
      "name": "Rabbit Hutch",
      "price": 40.0,
      "category": "Homes",
      "pet": "Rabbit",
      "image":
      "https://m.media-amazon.com/images/I/81n9NeZ2ggS._AC_SL1500_.jpg",
      "isFav": false
    },
    {
      "name": "Bird Food",
      "price": 10.0,
      "category": "Food & Treats",
      "pet": "Bird",
      "image":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSELFoxSzg8MyFSIFErMMEaLXdOaeJgIQWJ7Q&s",
      "isFav": false
    },
    {
      "name": "Aquarium",
      "price": 60.0,
      "category": "Homes",
      "pet": "Fish",
      "image":
      "https://cdn.britannica.com/29/121829-050-911F77EC/freshwater-aquarium.jpg",
      "isFav": false
    },

    {
      "name": "Dog Leash",
      "price": 6.7,
      "category": "Accessories",
      "pet": "Dog",
      "image":
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn7V0fsG2gQZUTCl5iEHs1JUV8W5Twx_oHUA&s",
      "isFav": false
    },
    {
      "name": "Bird Stand",
      "price": 13.0,
      "category": "Accessories",
      "pet": "Bird",
      "image":
      "https://i5.walmartimages.com/seo/Pretyzoom-1pc-Colorful-Wooden-Bird-Swing-For-Parrots-Roosters-And-Other-Pets-For-Climbing-And-Exploring_3148dfa6-6c1d-4175-987f-1665ec28e12d.def9a40a4b9a89415accb8de2c50b200.jpeg",
      "isFav": false
    },
  ];

  // Filters
  String searchQuery = "";
  String selectedPet = "All";
  String selectedCategory = "All";
  double minPrice = 0;
  double maxPrice = 100;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF0DB14C);

    // Apply filters
    List<Map<String, dynamic>> filteredProducts = products.where((product) {
      final matchesSearch = product["name"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesPet = selectedPet == "All" || product["pet"] == selectedPet;
      final matchesCategory =
          selectedCategory == "All" || product["category"] == selectedCategory;
      final matchesPrice = product["price"] >= minPrice &&
          product["price"] <= maxPrice;

      return matchesSearch && matchesPet && matchesCategory && matchesPrice;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const CustomAppBar(
        title: "Pet Store",
        showMenu: true,
        actionIcon: Icons.favorite_border,
      ),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         ElevatedButton.icon(
              //           onPressed: () {},
              //           icon: const Icon(Icons.favorite_border, size: 18),
              //           label: const Text("Wishlist"),
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.green,
              //             foregroundColor: Colors.white,
              //             padding: const EdgeInsets.all(10.0),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search pet accessories...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () => _showPriceFilter(context),
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

              // Pets Row
              const Text("Pets",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategory("images/cat.png", "Cat", Colors.green.shade100),
                  _buildCategory("images/dog.png", "Dog", Colors.blue.shade100),
                  _buildCategory(
                      "images/fish.png", "Fish", Colors.orange.shade100),
                  _buildCategory(
                      "images/bird.png", "Bird", Colors.purple.shade100),
                  _buildCategory("images/rabbit.png", "Rabbit",
                      Colors.yellow.shade100),
                ],
              ),
              const SizedBox(height: 20),

              // Popular Product
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Categories",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See All",
                      style: TextStyle(
                          color: greenColor, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),

              // Horizontal Tags
              SizedBox(
                height: 35,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTag("All"),
                    _buildTag("Food & Treats"),
                    _buildTag("Health"),
                    _buildTag("Grooming"),
                    _buildTag("Homes"),
                    _buildTag("Toys"),
                    _buildTag("Accessories"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Products Grid
              GridView.builder(

                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Category with selection border
  Widget _buildCategory(String image, String title, Color bgColor) {
    final isSelected = selectedPet == title;
    return GestureDetector(
      onTap: () => setState(() {
        if (selectedPet == title) {
          // 👇 if tapped again, reset to "All"
          selectedPet = "All";
        } else {
          selectedPet = title;
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
              backgroundImage: AssetImage(image),
            ),
          ),
          const SizedBox(height: 6),
          Text(title),
        ],
      ),
    );
  }

  // Build horizontal tags
  Widget _buildTag(String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0DB14C) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500),
        ),
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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              )
            ],
            color: Colors.white, // keep clean background
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with fav icon on top
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        product["image"],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ),

                  // Favorite button
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
                        scale: product["isFav"] ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            product["isFav"]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product["isFav"] ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product name & price
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${product["price"]}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // // Product Card
  // Widget _buildProductCard(Map<String, dynamic> product, int index) {
  //   return StatefulBuilder(
  //     builder: (context, setLocalState) {
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeInOut,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.shade300,
  //               blurRadius: 5,
  //               spreadRadius: 1,
  //               offset: const Offset(0, 2),
  //             )
  //           ],
  //         ),
  //         child: Stack(
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 Expanded(
  //                   child: ClipRRect(
  //                     borderRadius: const BorderRadius.vertical(
  //                         top: Radius.circular(16)),
  //                     child: Image.network(product["image"], fit: BoxFit.cover),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(product["name"],
  //                       style: const TextStyle(
  //                           fontWeight: FontWeight.w500, fontSize: 14)),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(
  //                     "\$${product["price"]}",
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Positioned(
  //               top: 10,
  //               right: 8,
  //               child: GestureDetector(
  //                 onTap: () {
  //                   setLocalState(() {
  //                     product["isFav"] = !product["isFav"];
  //                   });
  //                 },
  //                 child: AnimatedScale(
  //                   scale: product["isFav"] ? 1.3 : 1.0,
  //                   duration: const Duration(milliseconds: 300),
  //                   curve: Curves.easeInOut,
  //                   child: Icon(
  //                     product["isFav"]
  //                         ? Icons.favorite
  //                         : Icons.favorite_border,
  //                     color: product["isFav"] ? Colors.red : Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Bottom sheet filter
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
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
