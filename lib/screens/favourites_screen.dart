import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../utils/constants.dart';
import 'movie_detail_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    final favourites = provider.favourites;

    if (favourites.isEmpty) {
      return const Center(child: Text('No favourites yet.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.6, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        final movie = favourites[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailScreen(movie: movie),
            ),
          ),
          child: Column(
            children: [
              Image.network('$kImageBaseUrl${movie.posterPath}', height: 180, fit: BoxFit.cover),
              Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}
