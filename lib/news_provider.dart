import 'package:flutter/material.dart';
import 'news_api_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsApiService _newsApiService = NewsApiService();
  List<dynamic> _articles = [];
  List<dynamic> get articles => _articles;

  Future<void> fetchTopNews() async {
    _articles = await _newsApiService.fetchTopNews();
    notifyListeners();
  }

  Future<void> fetchArticles(String category) async {
    _articles = await _newsApiService.fetchNews(category);
    notifyListeners();
  }

  Future<void> searchArticles(String query) async {
    _articles = await _newsApiService.searchArticles(query);
    notifyListeners();
  }
}
