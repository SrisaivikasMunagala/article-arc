import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'news_card.dart';

class NewsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News',
          style: GoogleFonts.roboto(
            color: Colors.black, // Ensure title contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // AppBar stays white
        elevation: 0, // Optional: Remove AppBar shadow
        iconTheme:
            const IconThemeData(color: Colors.black), // Back button color
      ),
      backgroundColor: Colors.white, // Set the body background color to white
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.articles.isEmpty) {
            return Center(
              child: Text(
                'No articles available.',
                style: GoogleFonts.lato(
                  color: Colors.black, // Optional: Black text for contrast
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: newsProvider.articles.length,
            itemBuilder: (context, index) {
              final article = newsProvider.articles[index];
              return NewsCard(
                title: article['title'] ?? 'No title',
                imageUrl:
                    article['urlToImage'] ?? 'https://via.placeholder.com/150',
                description:
                    article['description'] ?? 'No description available',
                url: article['url'] ?? '', // Pass the URL to the NewsCard
              );
            },
          );
        },
      ),
    );
  }
}
