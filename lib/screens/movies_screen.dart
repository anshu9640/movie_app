import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../providers/movie_provider.dart';
import 'movie_detail_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Movie>> _movies;
  Map<int, String> _genres = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _genres = await ApiService.fetchGenres();
    setState(() {});
    _movies = ApiService.fetchMovies();
  }

  void _searchMovies(String query) {
    setState(() {
      _movies = ApiService.fetchMovies(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          "🎬 Movies",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔍 Search bar under the AppBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search movies...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onSubmitted: _searchMovies,
            ),
          ),

          // 🎞️ Movies Grid
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _movies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No movies found",
                          style: TextStyle(fontSize: 16)));
                }

                final movies = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.63, // ✅ Fix overflow and balance height
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    final isFav = provider.favourites.any((m) => m.id == movie.id);
                    final isWatch =
                        provider.watchlist.any((m) => m.id == movie.id);

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailScreen(movie: movie),
                        ),
                      ),
                      child: Card(
                        elevation: 6,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadowColor: Colors.deepPurple.shade100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🖼️ Movie Poster (Full)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                '$kImageBaseUrl${movie.posterPath}',
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image,
                                        size: 80, color: Colors.grey),
                              ),
                            ),

                            // 🎬 Movie Info
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              child: Column(
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    movie.genreIds.isNotEmpty
                                        ? _genres[movie.genreIds.first] ??
                                            'Unknown'
                                        : 'Unknown',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ❤️ Favourite & ⏰ Watchlist
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          isFav ? Colors.red : Colors.grey[500],
                                    ),
                                    onPressed: () =>
                                        provider.toggleFavourite(movie),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isWatch
                                          ? Icons.watch_later
                                          : Icons.watch_later_outlined,
                                      color: isWatch
                                          ? Colors.deepPurple
                                          : Colors.grey[500],
                                    ),
                                    onPressed: () =>
                                        provider.toggleWatchlist(movie),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
