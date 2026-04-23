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
    final movieAsync = ref.watch(movieDetailProvider(movieId));
    final theme = Theme.of(context);

    return Scaffold(
      body: movieAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            // --- 1. Top Parallax Header ---
            SliverAppBar(
              expandedHeight:
                  350, // Increased height for a more impactful hero image
              pinned: true,
              stretch:
                  true, // Allows stretching for a pull-to-refresh bounce effect
              backgroundColor: theme.scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (movie.backdropImageUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: movie.backdropImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ShimmerPlaceholder(),
                      ),
                    // Dual Gradient: Darkens the bottom to make text pop,
                    // darkens the top for back button visibility
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                            Colors.black45,
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. Refined Content Section ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // [Information Capsules] Rating and Date
                    Row(
                      children: [
                        _buildInfoChip(
                          context,
                          icon: Icons.star_rounded,
                          iconColor: Colors.amber,
                          text: '${movie.voteAverage.toStringAsFixed(1)} / 10',
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          context,
                          icon: Icons.calendar_today_rounded,
                          text: movie.releaseDate ?? 'Unknown',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // [Primary Action Buttons] Trailer and Bookmark
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              // TODO: Trailer playback logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Preparing to play trailer...'),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text(
                              'Watch Trailer',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          onPressed: () {
                            // TODO: Bookmark logic
                          },
                          icon: const Icon(Icons.bookmark_border_rounded),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // [Synopsis]
                    Text(
                      'Synopsis',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'No synopsis available for this movie.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.grey[300],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // [UI Placeholder] Cast (Ready for API integration)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Main Cast',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Horizontal scrolling skeleton preview
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) => Column(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.black26,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 12,
                              color: Colors.grey[800],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100), // Bottom spacing
                  ],
                ),
              ),
            ),
          ],
        ),

        error: (err, stack) => Scaffold(
          appBar: AppBar(),
          body: ErrorMessageWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
          ),
        ),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  // Independent Info Capsule UI Component
  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor ?? Colors.grey[400]),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
