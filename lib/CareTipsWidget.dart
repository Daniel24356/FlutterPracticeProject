import 'package:flutter/material.dart';

class CareTipsWidget extends StatefulWidget {
  const CareTipsWidget({super.key});

  @override
  State<CareTipsWidget> createState() => _CareTipsWidgetState();
}

class _CareTipsWidgetState extends State<CareTipsWidget> {
  String searchTerm = "";
  String selectedCategory = "all";
  List<String> bookmarked = [];

  // Mock data
  final List<Map<String, dynamic>> categories = [
    {"value": "all", "label": "All Topics"},
    {"value": "nutrition", "label": "Nutrition", "icon": "🥘"},
    {"value": "training", "label": "Training", "icon": "🎾"},
    {"value": "health", "label": "Health & Wellness", "icon": "❤️"},
    {"value": "grooming", "label": "Grooming", "icon": "✂️"},
    {"value": "behavior", "label": "Behavior", "icon": "🧠"},
    {"value": "emergency", "label": "Emergency Care", "icon": "🚨"},
  ];

  final List<Map<String, dynamic>> articles = [
    {
      "id": "1",
      "title": "Complete Guide to Dog Nutrition",
      "excerpt":
      "Essential nutrients your dog needs, how to read labels, and create a balanced diet.",
      "category": "nutrition",
      "author": "Dr. Sarah Williams",
      "authorRole": "Veterinary Nutritionist",
      "publishDate": "2024-09-01",
      "readTime": "8 min read",
      "image": "🥘",
      "featured": true,
      "tags": ["nutrition", "diet", "health"]
    },
    {
      "id": "2",
      "title": "Emergency First Aid for Pets",
      "excerpt":
      "Cuts, burns, choking, poisoning – learn essential pet first aid steps.",
      "category": "emergency",
      "author": "Dr. Michael Chen",
      "authorRole": "Emergency Veterinarian",
      "publishDate": "2024-08-28",
      "readTime": "12 min read",
      "image": "🚨",
      "urgent": true,
      "tags": ["emergency", "safety"]
    },
    {
      "id": "3",
      "title": "Positive Reinforcement Training",
      "excerpt":
      "Strengthen your bond with your dog through positive reinforcement.",
      "category": "training",
      "author": "Lisa Thompson",
      "authorRole": "Dog Trainer",
      "publishDate": "2024-08-25",
      "readTime": "6 min read",
      "image": "🎾",
      "tags": ["training", "behavior"]
    },
  ];

  void toggleBookmark(String id) {
    setState(() {
      if (bookmarked.contains(id)) {
        bookmarked.remove(id);
      } else {
        bookmarked.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final featuredArticle =
    articles.firstWhere((a) => a["featured"] == true, orElse: () => {});
    final filteredArticles = articles.where((article) {
      final matchesCategory =
          selectedCategory == "all" || article["category"] == selectedCategory;
      final matchesSearch = searchTerm.isEmpty ||
          article["title"].toLowerCase().contains(searchTerm.toLowerCase()) ||
          article["excerpt"].toLowerCase().contains(searchTerm.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Article
          if (featuredArticle.isNotEmpty) ...[
            const Text("Featured Article",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              color: Colors.purple.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(featuredArticle["image"] ?? "",
                        style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(featuredArticle["title"],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(featuredArticle["excerpt"],
                              style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 8),
                          Text(
                              "${featuredArticle["author"]} • ${featuredArticle["readTime"]}",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Read Full Article"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Search + Filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search articles, topics...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) => setState(() => searchTerm = val),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem<String>(
                  value: c["value"] as String, // 👈 cast here
                  child: Text(c["label"] as String), // 👈 cast here
                ))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val ?? "all"),
              ),

            ],
          ),
          const SizedBox(height: 24),

          // Articles
          if (filteredArticles.isEmpty)
            const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text("No Articles Found"),
                ))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(article["image"] ?? "",
                                    style: const TextStyle(fontSize: 28)),
                                IconButton(
                                  icon: Icon(
                                    bookmarked.contains(article["id"])
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.purple,
                                  ),
                                  onPressed: () =>
                                      toggleBookmark(article["id"]),
                                ),
                              ]),
                          Text(article["title"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(article["excerpt"],
                              style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 14),
                              const SizedBox(width: 4),
                              Text(article["author"],
                                  style: TextStyle(color: Colors.grey[600])),
                              const SizedBox(width: 12),
                              const Icon(Icons.schedule, size: 14),
                              const SizedBox(width: 4),
                              Text(article["readTime"],
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ]),
                  ),
                );
              },
            ),

          const SizedBox(height: 24),
          // Quick Category Links
          const Text("Browse by Topic",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: categories
                .where((c) => c["value"] != "all")
                .map((c) => GestureDetector(
              onTap: () =>
                  setState(() => selectedCategory = c["value"]),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c["icon"] ?? "",
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text(c["label"],
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ))
                .toList(),
          )
        ],
      ),
    );
  }
}
