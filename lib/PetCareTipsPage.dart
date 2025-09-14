import 'package:flutter/material.dart';

class PetCareTipsPage extends StatelessWidget {
  const PetCareTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF0DB14C);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          "Pet Care Tips",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Featured Article",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // -------------------- Featured Article Card --------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      _buildTag("Featured", Colors.green[100]!, Colors.green),
                      const SizedBox(width: 8),
                      _buildTag("Nutrition", Colors.blue[100]!, Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  const Text(
                    "Complete Guide to Dog Nutrition: What Every Pet Owner Should Know",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    "Learn about the essential nutrients your dog needs, how to read pet food labels, and create a balanced diet plan for optimal health.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Author + meta info
                  Row(
                    children: const [
                      Text(
                        "Dr. Sarah Williams · Veterinary Nutritionist",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 14, color: Colors.black45),
                      SizedBox(width: 4),
                      Text("8 min read",
                          style:
                          TextStyle(fontSize: 12, color: Colors.black54)),
                      SizedBox(width: 16),
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.black45),
                      SizedBox(width: 4),
                      Text("2024-09-01",
                          style:
                          TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                          "Read Full Article",
                          style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // // Bottom Icon
                  // Center(
                  //   child: Icon(
                  //     Icons.pets,
                  //     size: 48,
                  //     color: greenColor,
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -------------------- Browse by Topic --------------------
            const Text(
              "Browse by Topic",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopicCard("Nutrition", "3 articles"),
                _buildTopicCard("Training", "2 articles"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Tag widget ----------
  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // ---------- Topic card widget ----------
  Widget _buildTopicCard(String title, String subtitle) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "images/training.png", // <--- your image here
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
