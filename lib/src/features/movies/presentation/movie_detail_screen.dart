import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_browser/src/common_widgets/error_message_widget.dart';
import 'package:movie_browser/src/common_widgets/shimmer_placeholder.dart';
import 'package:movie_browser/src/features/movies/data/movies_repository.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';

// Changed to ConsumerWidget to read Riverpod state
class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({required this.movieId, super.key});
  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass in movieId to listen to the state of this specific movie
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      body: movieAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            // 1. Collapsible parallax scrolling header (SliverAppBar)
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true, // Keep the AppBar at the top when scrolling down
              flexibleSpace: FlexibleSpaceBar(
                title: Text(movie.title),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Large background image of the movie
                    if (movie.backdropImageUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: movie.backdropImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ShimmerPlaceholder(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    // Add a black gradient to make the white title text clearer
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black87,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Content area (SliverToBoxAdapter)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating and date
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          'Release Date: ${movie.releaseDate ?? 'Unknown'}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey[400],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Overview title
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Overview content
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'There is no overview available for this movie.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height:
                            1.5, // Increase line height for more comfortable reading
                      ),
                    ),

                    // Bottom padding
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Error state
        error: (err, stack) => Scaffold(
          appBar:
              AppBar(), // Provide a default AppBar so the user can navigate back
          body: ErrorMessageWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
          ),
        ),

        // Loading state
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
