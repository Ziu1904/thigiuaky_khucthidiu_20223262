import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin Tức Yêu Thích'),
      ),
      body: provider.isFavoritesLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Vui lòng chờ 3 giây...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : favorites.isEmpty
              ? const Center(child: Text('Chưa có bài viết yêu thích nào.'))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final article = favorites[index];
                    return ArticleCard(
                      article: article,
                      isFavorite: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(article: article),
                        ),
                      ),
                      onFavoriteTap: () => provider.toggleFavorite(article),
                    );
                  },
                ),
    );
  }
}
