import 'package:flutter/material.dart';
import 'anime_screen.dart';

class PriorScreen extends StatelessWidget {
  const PriorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white70, // Set background color
      body: SingleChildScrollView( // Add SingleChildScrollView to prevent overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.7,
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/anime.jpg'), // Set your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Welcome to Anime Search',
              style: TextStyle(
                color: Color(0xff302360),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnimeSearchScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff302360),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Search Anime',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
