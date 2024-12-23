import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryBar extends StatefulWidget {
  final void Function(String) onCategorySelected;

  const CategoryBar({super.key, required this.onCategorySelected});

  @override
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  final List<Map<String, dynamic>> categories = [
    {
      'icon': 'assets/news.png',
      'label': 'Top Headlines',
      'query': 'general',
    },
    {
      'icon': 'assets/sports.png',
      'label': 'Sports',
      'query': 'sports',
    },
    {
      'icon': 'assets/wallet.png',
      'label': 'Business',
      'query': 'business',
    },
    {
      'icon': 'assets/technology.png',
      'label': 'Technology',
      'query': 'technology',
    },
    {
      'icon': 'assets/movie.png',
      'label': 'Entertainment',
      'query': 'entertainment',
    },
    {
      'icon': 'assets/health.png',
      'label': 'Health',
      'query': 'health',
    },
    {
      'icon': 'assets/science.png',
      'label': 'Science',
      'query': 'science',
    },
  ];

  String _selectedCategory = 'latest'; // Track the selected category

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Increased height for larger icons
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = _selectedCategory == category['query'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory =
                    category['query']; // Update selected category
              });
              widget.onCategorySelected(category['query']);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spotlight effect with the selected category
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(
                        12), // Adjust padding for the spotlight
                    child: category['icon']
                            .toString()
                            .contains('assets/') // Check if it's an image
                        ? Image.asset(
                            category['icon'],
                            height: 40, // Increased icon height
                            width: 40, // Increased icon width
                          )
                        : Text(
                            category['icon'] ?? '',
                            style: const TextStyle(
                                fontSize:
                                    28), // Larger font size for text icons
                          ),
                  ),
                  const SizedBox(height: 8), // Increased spacing
                  Text(
                    category['label'] ?? '',
                    style: GoogleFonts.notoSans(
                      fontSize: 14, // Slightly larger font size
                      color: isSelected ? Colors.blue : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
