import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:thigiuaky_khucthidiu_20223262/main.dart';
import 'package:thigiuaky_khucthidiu_20223262/providers/news_provider.dart';

void main() {
  testWidgets('News app smoke test', (WidgetTester tester) async {
    // Xây dựng ứng dụng và kích hoạt một frame.
    // Vì MyApp sử dụng Provider, chúng ta cần bọc nó trong ChangeNotifierProvider trong test
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NewsProvider(),
        child: const MyApp(),
      ),
    );

    // Kiểm tra xem tiêu đề 'Tin Tức Mới' có xuất hiện không.
    expect(find.text('Tin Tức Mới'), findsOneWidget);

    // Kiểm tra xem ô tìm kiếm có tồn tại không.
    expect(find.byType(TextField), findsOneWidget);

    // Kiểm tra xem icon yêu thích có tồn tại trên AppBar không.
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
