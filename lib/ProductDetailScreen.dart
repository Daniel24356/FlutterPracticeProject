import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedColorIndex = 0;
  String selectedSize = "M";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shoe Image
            Center(
              child: Image.network(
                "https://img.ssensemedia.com/images/231469M237001_1/balenciaga-black-bouncer-sneakers.jpg",
                height: 200,
              ),
            ),

            const SizedBox(height: 16),

            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Card with product details
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.directions_run, color: Colors.orange),
                          SizedBox(width: 6),
                          Text(
                            "Shoes",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.share, color: Colors.orange),
                          SizedBox(width: 12),
                          Icon(Icons.favorite_border, color: Colors.orange),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Balenciaga Bouncer Sneaker",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Balenciaga Bouncer sneakers are chunky sneakers with exaggerated soles and a tire tread.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // Colors
                  const Text(
                    "Colors",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(2, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedColorIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColorIndex == index
                                  ? Colors.orange
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: index == 0 ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Price
                  const Text(
                    "Price",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "1,200\$",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Add to Cart Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sizes
            const Text(
              "Available Sizes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: ["XS", "S", "M", "L"].map((size) {
                bool isSelected = selectedSize == size;
                return GestureDetector(
                  onTap: () => setState(() => selectedSize = size),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Detailed Information
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text(
                "Detailed Information",
                style: TextStyle(color: Colors.black),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Balenciaga Bouncer sneakers are chunky sneakers with exaggerated soles and a tire tread. They're part of the brand's SS23 Red Carpet Collection and are available in men's and women's sizes. The sneakers are made from mesh and rubber panels, with padded collars for comfort, and have a lace-up front.",
              style: TextStyle(color: Colors.black87),
            ),

            const SizedBox(height: 6),
            const Text(
              "Read More",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
