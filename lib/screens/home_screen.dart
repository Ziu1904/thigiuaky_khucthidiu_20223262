import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().loadArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final filteredArticles = provider.searchArticles(_searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin Tức Mới'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      // THÊM MENU DRAWER Ở ĐÂY
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context); // Đóng menu
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Giới thiệu'),
              onTap: () {
                Navigator.pop(context);
                // Bạn có thể thêm điều hướng đến màn hình giới thiệu ở đây
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () {
                Navigator.pop(context);
                // Bạn có thể thêm điều hướng đến màn hình cài đặt ở đây
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: provider.loadArticles,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm bài viết...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.loadArticles,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
                  : filteredArticles.isEmpty
                  ? const Center(child: Text('Không tìm thấy bài viết nào'))
                  : ListView.builder(
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  final article = filteredArticles[index];
                  return ArticleCard(
                    article: article,
                    isFavorite: provider.isFavorite(article),
                    onFavoriteTap: () => provider.toggleFavorite(article),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
