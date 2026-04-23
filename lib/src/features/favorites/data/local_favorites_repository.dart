import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_favorites_repository.g.dart';

class LocalFavoritesRepository {
  // Get the box that was opened in main.dart
  final Box<String> _box = Hive.box<String>('favorites');

  // Retrieve all favorited movies
  List<Movie> getFavorites() {
    return _box.values.map((jsonString) {
      return Movie.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    }).toList();
  }

  // Check if a specific movie is in favorites
  bool isFavorite(int movieId) {
    return _box.containsKey(movieId);
  }

  // Add or remove from favorites (Toggle)
  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      await _box.delete(movie.id); // Remove if already exists
    } else {
      // Encode to JSON string and store using movieId as the key
      final jsonString = jsonEncode(movie.toJson());
      await _box.put(movie.id, jsonString);
    }
  }
}

// Create a Provider to allow other parts of the app to access the Repository
@riverpod
LocalFavoritesRepository localFavoritesRepository(
  LocalFavoritesRepositoryRef ref,
) {
  return LocalFavoritesRepository();
}
