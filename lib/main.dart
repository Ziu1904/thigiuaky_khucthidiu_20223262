import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tin Tức',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomeScreen(),
      routes: {
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}
