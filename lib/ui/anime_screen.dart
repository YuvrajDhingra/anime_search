import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../model/anime_model.dart';

class AnimeSearchScreen extends StatefulWidget {
  const AnimeSearchScreen({super.key});

  @override
  _AnimeSearchScreenState createState() => _AnimeSearchScreenState();
}

class _AnimeSearchScreenState extends State<AnimeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Data> _searchResults = [];
  List<Data> _allAnime = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAllAnime();
  }

  Future<void> _loadAllAnime() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      const String apiUrl = 'https://api.jikan.moe/v4/anime';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          setState(() {
            _allAnime = (jsonData['data'] as List)
                .map((item) => Data.fromJson(item))
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load anime data ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading anime data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _searchAnime(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final String apiUrl = 'https://api.jikan.moe/v4/anime?q=$query';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          setState(() {
            _searchResults = (jsonData['data'] as List)
                .map((item) => Data.fromJson(item))
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load search results ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading search results: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _launchTrailer(Uri trailerUrl) async {
    if (await canLaunchUrl(trailerUrl)) {
      await launchUrl(trailerUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trailer Not Available'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f1545),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1f1545),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Search for an Anime',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff302360),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'eg: One Piece',
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.purple.shade600,
              ),
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  await _searchAnime(value);
                } else {
                  setState(() {
                    _searchResults.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(_errorMessage,
                            style: const TextStyle(color: Colors.red)))
                    : Expanded(
                        child: _searchResults.isEmpty
                            ? _buildAllAnimeList()
                            : _buildSearchResultsList(),
                      ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadAllAnime,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllAnimeList() {
    return ListView.builder(
      itemCount: _allAnime.length,
      itemBuilder: (context, index) {
        Data anime = _allAnime[index];
        return _buildAnimeTile(anime);
      },
    );
  }
  Widget _buildSearchResultsList() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        Data anime = _searchResults[index];
        return _buildAnimeTile(anime);
      },
    );
  }
  Widget _buildAnimeTile(Data anime) {
    return Card(
      color: const Color(0xff302360),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              anime.title ?? 'No title available',
              style: const TextStyle(color: Colors.white),
            ),
            if (anime.url != null)
              Text(
                anime.url!,
                style: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            if (anime.trailer != null && anime.trailer!.embedUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Trailer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isValidYouTubeId(anime.trailer!.youtubeId))
                    SizedBox(
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          if (anime.trailer != null && anime.trailer!.url != null) {
                            _launchTrailer(Uri.parse(anime.trailer!.embedUrl!));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Trailer Not Available'),
                              ),
                            );
                          }
                        },
                        child: Image.network(
                          'https://img.youtube.com/vi/${anime.trailer!.youtubeId}/0.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Thumbnail Not Available');
                          },
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
        leading: anime.images?.jpg != null
            ? SizedBox(
          width: 80,
          child: Image.network(
            anime.images!.jpg!.largeImageUrl!,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        )
            : null,
      ),
    );
  }

  bool _isValidYouTubeId(String? id) {
    if (id == null) return false;
    final validYouTubeIdRegex = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return validYouTubeIdRegex.hasMatch(id);
  }

}
