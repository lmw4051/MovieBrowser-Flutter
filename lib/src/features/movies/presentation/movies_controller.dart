import 'package:movie_browser/src/features/movies/data/movies_repository.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_controller.g.dart';

@riverpod
class PopularMoviesController extends _$PopularMoviesController {
  @override
  FutureOr<List<Movie>> build() async {
    // Initially load the first page
    final repository = ref.watch(moviesRepositoryProvider);
    final response = await repository.getPopularMovies();
    return response.results;
  }

  // Logic to fetch the next page
  Future<void> fetchNextPage() async {
    // Prevent duplicate triggers if currently loading
    if (state.isLoading || !state.hasValue) return;

    final repository = ref.watch(moviesRepositoryProvider);
    final currentMovies = state.value ?? [];

    // Calculate the next page number (This is a simplified version;
    // in practice, you can track totalPages from TmdbMoviesResponse)
    final nextPage = (currentMovies.length ~/ 20) + 1;

    state = const AsyncLoading<List<Movie>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final response = await repository.getPopularMovies(page: nextPage);
      return [...currentMovies, ...response.results];
    });
  }
}
