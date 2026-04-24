import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_browser/src/features/favorites/presentation/favorites_controller.dart';
import 'package:movie_browser/src/features/movies/presentation/movie_card.dart'; // Remember to import the router

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 Easily read the favorites list
    // (this will automatically re-render when you add/remove favorites)
    final favorites = ref.watch(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: favorites.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return MovieCard(
                  movie: movie,
                  onTap: () async {
                    // 💡 Note: Using push instead of go is recommended here.
                    // push stacks the detail page on top of the favorites page,
                    // ensuring you return to the favorites list
                    // when pressing the back button!
                    await context.push('/movie/${movie.id}');
                  },
                );
              },
            ),
    );
  }

  // Separate UI component for the empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorite movies yet!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore the home screen and add movies you like',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
