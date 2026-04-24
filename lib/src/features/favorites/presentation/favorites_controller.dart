import 'package:movie_browser/src/features/favorites/data/local_favorites_repository.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_controller.g.dart';

@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  List<Movie> build() {
    // Initial state: Fetch the current favorites list from the Repository
    final repository = ref.watch(localFavoritesRepositoryProvider);
    return repository.getFavorites();
  }

  // The UI calls this method to toggle the favorite status
  Future<void> toggleFavorite(Movie movie) async {
    final repository = ref.read(localFavoritesRepositoryProvider);
    await repository.toggleFavorite(movie);

    // Update the state (this triggers UI re-rendering)
    // Re-read the latest state from Hive to overwrite, ensuring data consistency
    state = repository.getFavorites();
  }

  // Helper method for the UI to determine if a movie is favorited
  bool isFavorite(int movieId) {
    // The 'any' method checks if there is an element
    // in the list that matches the condition
    return state.any((movie) => movie.id == movieId);
  }
}
