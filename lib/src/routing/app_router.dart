import 'package:go_router/go_router.dart';
import 'package:movie_browser/src/features/movies/presentation/movie_detail_screen.dart';
import 'package:movie_browser/src/features/movies/presentation/movies_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MoviesScreen(),
      ),
      GoRoute(
        path: '/movie/:id',
        name: 'movieDetail',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailScreen(movieId: movieId);
        },
      ),
    ],
  );
}
