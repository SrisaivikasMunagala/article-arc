import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsReaderService {
  final String _apiUrl =
      'https://mercury-reader-b77ae96c2023.herokuapp.com/parse'; // Replace with your deployed backend URL: https://mercury-backend-summer-cherry-1817.fly.dev/parse

  Future<Map<String, dynamic>> fetchArticleContent(String url) async {
    final response = await http.get(Uri.parse('$_apiUrl?url=$url'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch article content');
    }
  }
}
