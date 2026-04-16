import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';

class NewsProvider extends ChangeNotifier {
  List<Article> articles = [];
  List<Article> favorites = [];
  
  bool isLoading = false;          // Cho trang chủ
  bool isFavoritesLoading = false; // RIÊNG cho danh sách yêu thích
  String? error;

  NewsProvider() {
    _loadFavorites();
  }

  // Tải tin tức trang chủ
  Future<void> loadArticles() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Giả lập thời gian chờ (Bạn có thể sửa số 3 thành số khác)
      await Future.delayed(const Duration(seconds: 3));

      const apiUrl = 'https://api.rss2json.com/v1/api.json?rss_url=https://news.google.com/rss?hl=vi&gl=VN&ceid=VN:vi';
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List items = data['items'];
          articles = items.map((json) => Article.fromJson(json)).toList();
        }
      } else {
        error = 'Lỗi server: ${response.statusCode}';
      }
    } catch (e) {
      error = 'Lỗi kết nối: Vui lòng kiểm tra internet!';
    }

    isLoading = false;
    notifyListeners();
  }

  // Tải danh sách yêu thích từ máy
  Future<void> _loadFavorites() async {
    isFavoritesLoading = true; // Bắt đầu tải yêu thích
    notifyListeners();

    // GIẢ LẬP GIÂY CHỜ CHO YÊU THÍCH (Bạn có thể sửa số 3 ở đây)
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final String? favString = prefs.getString('favorites_list');
    if (favString != null) {
      try {
        final List decoded = json.decode(favString);
        favorites = decoded.map((item) => Article.fromJson(item)).toList();
      } catch (e) {
        debugPrint('Error loading favorites: $e');
      }
    }
    
    isFavoritesLoading = false; // Kết thúc tải
    notifyListeners();
  }

  void toggleFavorite(Article article) {
    final index = favorites.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      favorites.removeAt(index);
    } else {
      favorites.add(article);
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Article article) => favorites.any((a) => a.id == article.id);

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(favorites.map((a) => a.toJson()).toList());
    await prefs.setString('favorites_list', encodedData);
  }

  List<Article> searchArticles(String query) {
    if (query.isEmpty) return articles;
    return articles.where((a) => a.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
