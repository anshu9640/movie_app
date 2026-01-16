import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';
import '../utils/constants.dart';

class ApiService {
  // Fetch movies or search results
  static Future<List<Movie>> fetchMovies({String query = ''}) async {
    final url = query.isEmpty
        ? Uri.parse('$kBaseUrl/movie/popular?api_key=$kTMDBApiKey')
        : Uri.parse('$kBaseUrl/search/movie?api_key=$kTMDBApiKey&query=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  // Fetch genre names
  static Future<Map<int, String>> fetchGenres() async {
    final url = Uri.parse('$kBaseUrl/genre/movie/list?api_key=$kTMDBApiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List genres = jsonDecode(response.body)['genres'];
      return {for (var g in genres) g['id']: g['name']};
    } else {
      throw Exception('Failed to load genres');
    }
  }
}
