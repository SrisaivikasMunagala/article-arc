import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String _apiKey =
      'ecb49fb94beb43688d5cdfb8eb47c5e4'; // Replace with your NewsAPI key.

  // Fetch top news (default query for top headlines)
  Future<List<dynamic>> fetchTopNews() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?apiKey=$_apiKey&language=en&pageSize=20',
    ); // Added 'pageSize=20' for more articles
    return _fetchArticlesFromUrl(url);
  }

  // Fetch news by category
  Future<List<dynamic>> fetchNews(String category) async {
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?apiKey=$_apiKey&category=$category&language=en&pageSize=20',
    );
    return _fetchArticlesFromUrl(url);
  }

  // Search for articles
  Future<List<dynamic>> searchArticles(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?apiKey=$_apiKey&q=$encodedQuery&language=en&pageSize=20',
    );
    return _fetchArticlesFromUrl(url);
  }

  // Common fetch logic
  Future<List<dynamic>> _fetchArticlesFromUrl(Uri url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final filteredArticles = data['articles']
          .where((article) =>
              article['title'] != null &&
              article['description'] != null &&
              article['url'] != null &&
              isValidUrl(article['urlToImage'])) // Ensure valid image URL
          .toList();

      return filteredArticles;
    } else {
      throw Exception('Failed to load news: ${response.reasonPhrase}');
    }
  }

  // Validate URLs
  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }
}
