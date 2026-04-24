import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_browser/src/common_widgets/error_message_widget.dart';
import 'package:movie_browser/src/common_widgets/shimmer_placeholder.dart';
import 'package:movie_browser/src/features/favorites/presentation/favorites_controller.dart';
import 'package:movie_browser/src/features/movies/data/movies_repository.dart';
import 'package:movie_browser/src/features/movies/domain/cast.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';

// Changed to ConsumerWidget to read Riverpod state
class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({required this.movieId, super.key});
  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      body: movieAsync.when(
        data: (movie) => CustomScrollView(
          slivers: [
            _MovieDetailAppBar(movie: movie),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MovieInfoSection(movie: movie),
                    const SizedBox(height: 24),
                    _MovieActionButtons(movie: movie),
                    const SizedBox(height: 32),
                    _MovieSynopsis(overview: movie.overview),
                    const SizedBox(height: 32),
                    _MovieCastSection(cast: movie.cast),
                    const SizedBox(height: 100),
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
}

class _MovieDetailAppBar extends StatelessWidget {
  const _MovieDetailAppBar({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
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
                placeholder: (context, url) => const ShimmerPlaceholder(),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent, Colors.black45],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieInfoSection extends StatelessWidget {
  const _MovieInfoSection({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoChip(
          icon: Icons.star_rounded,
          iconColor: Colors.amber,
          text: '${movie.voteAverage.toStringAsFixed(1)} / 10',
        ),
        const SizedBox(width: 12),
        _InfoChip(
          icon: Icons.calendar_today_rounded,
          text: movie.releaseDate ?? 'Unknown',
        ),
      ],
    );
  }
}

class _MovieActionButtons extends ConsumerWidget {
  const _MovieActionButtons({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoritesControllerProvider);
    final isFav = favorites.any((f) => f.id == movie.id);

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing to play trailer...')),
              );
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Watch Trailer', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        IconButton.filledTonal(
          onPressed: () {
            ref
                .read(favoritesControllerProvider.notifier)
                .toggleFavorite(movie);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav ? 'Removed from favorites' : 'Added to favorites',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          icon: Icon(
            isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: isFav ? theme.colorScheme.primary : null,
          ),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieSynopsis extends StatelessWidget {
  const _MovieSynopsis({required this.overview});
  final String overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Synopsis',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          overview.isNotEmpty
              ? overview
              : 'No synopsis available for this movie.',
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: Colors.grey[300],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _MovieCastSection extends StatelessWidget {
  const _MovieCastSection({required this.cast});
  final List<Cast> cast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: cast.isEmpty
              ? const Text('No Cast Info Available')
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final actor = cast[index];
                    return SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            backgroundImage: actor.profileImageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    actor.profileImageUrl,
                                  )
                                : null,
                            child: actor.profileImageUrl.isEmpty
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            actor.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text, this.iconColor});
  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
