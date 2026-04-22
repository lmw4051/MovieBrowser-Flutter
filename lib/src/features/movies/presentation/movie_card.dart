import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_browser/src/common_widgets/shimmer_placeholder.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';
import 'package:shimmer/shimmer.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    super.key,
    this.onTap,
  });

  final Movie movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Poster Image
            _PosterImage(imageUrl: movie.posterImageUrl),
            // Right Side Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.releaseDate ?? 'Unknown Date',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 150,
      child: imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerPlaceholder(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : const ColoredBox(
              color: Colors.grey,
              child: Icon(Icons.movie, size: 40),
            ),
    );
  }
}

class MovieCardSkeleton extends StatelessWidget {
  const MovieCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Left Poster Skeleton View
          SizedBox(
            width: 100,
            height: 150,
            child: ShimmerPlaceholder(),
          ),

          // 2. Right Side Text Info Skeleton View
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Skeleton View
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: ShimmerPlaceholder(),
                  ),
                  SizedBox(height: 8),

                  // Date Skeleton View
                  SizedBox(
                    height: 14,
                    width: 100,
                    child: ShimmerPlaceholder(),
                  ),
                  SizedBox(height: 16),

                  // Description Skeleton View
                  SizedBox(
                    height: 14,
                    width: double.infinity,
                    child: ShimmerPlaceholder(),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 14,
                    width: double.infinity,
                    child: ShimmerPlaceholder(),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 14,
                    width: 150,
                    child: ShimmerPlaceholder(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
