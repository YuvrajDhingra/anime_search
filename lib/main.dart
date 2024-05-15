import 'package:anime_search/ui/pre_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimeSearchApp());
}

class AnimeSearchApp extends StatelessWidget {
  const AnimeSearchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PriorScreen(),
    );
  }
}

