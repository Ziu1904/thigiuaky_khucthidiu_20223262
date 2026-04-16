class Article {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime publishedAt;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // 1. Xử lý ảnh
    String img = json['thumbnail'] ?? '';
    if (img.isEmpty && json['enclosure'] != null) {
      img = json['enclosure']['link'] ?? '';
    }

    if (img.isEmpty) {
      img = 'https://picsum.photos/id/${(json['title'] ?? '').length}/600/400';
    } else {
      img = "https://wsrv.nl/?url=${Uri.encodeComponent(img)}&n=-1";
    }

    // 2. Hàm hỗ trợ lọc sạch HTML
    String cleanHtml(String? html) {
      if (html == null) return '';
      return html
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }

    String title = cleanHtml(json['title']) != '' ? cleanHtml(json['title']) : 'Tin tức';
    String desc = cleanHtml(json['description']);
    String fullContent = cleanHtml(json['content'] ?? json['description']);

    if (fullContent.length < 50) {
      fullContent = "$title\n\n$desc";
    }

    return Article(
      id: json['guid'] ?? json['link'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: desc.length > 150 ? '${desc.substring(0, 147)}...' : desc,
      imageUrl: img,
      publishedAt: DateTime.tryParse(json['pubDate'] ?? '') ?? DateTime.now(),
      content: fullContent,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'publishedAt': publishedAt.toIso8601String(),
    'content': content,
  };
}
