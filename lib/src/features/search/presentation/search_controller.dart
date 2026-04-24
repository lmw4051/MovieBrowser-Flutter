import 'dart:async';

import 'package:movie_browser/src/features/movies/data/movies_repository.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  // Used to store the current timer instance
  Timer? _debounceTimer;

  @override
  AsyncValue<List<Movie>> build() {
    // Initial state: Return an empty list before any search is performed
    ref.onDispose(
      () {
        _debounceTimer
            ?.cancel(); // Cancel the timer when the controller is disposed
      },
    );
    return const AsyncData([]);
  }

  // The UI calls this method and passes the user's input string
  void search(String query) {
    // 1. Always cancel the previous pending timer first!
    // (The core of Debouncing)
    _debounceTimer?.cancel();

    // 2. If the user clears the input field,
    // reset the state to an empty list immediately
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    // 3. Switch the state to Loading
    state = const AsyncLoading();

    // 4. Set a new timer:
    //Wait for 500ms without interruption before calling the API
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final repository = ref.read(moviesRepositoryProvider);
        final response = await repository.searchMovies(query);

        // Successfully fetched data, update the state
        state = AsyncData(response.results);
      } catch (e, stack) {
        state = AsyncError(e, stack);
      }
    });
  }
}
