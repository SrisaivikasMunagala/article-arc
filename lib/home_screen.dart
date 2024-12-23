import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'category_bar.dart';
import 'news_card.dart';
import 'news_reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'general'; // Default category for news
  final TextEditingController _searchController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Fetch top news on launch
    Provider.of<NewsProvider>(context, listen: false).fetchTopNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    Provider.of<NewsProvider>(context, listen: false).fetchArticles(category);

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _onSearchSubmitted(String input) {
    if (Uri.tryParse(input)?.hasAbsolutePath ?? false) {
      // Direct link to reader
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsReaderScreen(url: input),
        ),
      );
    } else {
      // Search query
      Provider.of<NewsProvider>(context, listen: false).searchArticles(input);

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/aa_white.png',
          height: 160,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Paste a link to an article...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => _searchController.clear(),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _onSearchSubmitted,
            ),
          ),

          // Category Bar
          CategoryBar(onCategorySelected: _onCategorySelected),

          // News List
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                if (newsProvider.articles.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: newsProvider.articles.length,
                  itemBuilder: (context, index) {
                    final article = newsProvider.articles[index];
                    return NewsCard(
                      title: article['title'] ?? 'No title',
                      imageUrl: article['urlToImage'] ?? '',
                      description: article['description'] ?? '',
                      url: article['url'] ?? '',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
