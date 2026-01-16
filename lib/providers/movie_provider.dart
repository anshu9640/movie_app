import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  final List<Movie> _favourites = [];
  final List<Movie> _watchlist = [];

  List<Movie> get favourites => _favourites;
  List<Movie> get watchlist => _watchlist;

  void toggleFavourite(Movie movie) {
    if (_favourites.any((m) => m.id == movie.id)) {
      _favourites.removeWhere((m) => m.id == movie.id);
    } else {
      _favourites.add(movie);
    }
    notifyListeners();
  }

  void toggleWatchlist(Movie movie) {
    if (_watchlist.any((m) => m.id == movie.id)) {
      _watchlist.removeWhere((m) => m.id == movie.id);
    } else {
      _watchlist.add(movie);
    }
    notifyListeners();
  }
}
