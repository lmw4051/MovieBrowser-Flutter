import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_browser/src/features/movies/presentation/movie_card.dart';
import 'package:movie_browser/src/features/movies/presentation/movies_controller.dart';

class MoviesScreen extends ConsumerWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(popularMoviesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: moviesAsync.when(
        data: (movies) => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Trigger load more when scrolling
            // close to the bottom (200 pixels remaining)
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
              ref
                  .read(popularMoviesControllerProvider.notifier)
                  .fetchNextPage()
                  .ignore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: movies.length + 1,
            // +1 is to display the loading indicator at the bottom
            itemBuilder: (context, index) {
              if (index < movies.length) {
                return MovieCard(
                  movie: movies[index],
                  onTap: () {},
                );
              } else {
                return const MovieCardSkeleton();
                // Bottom loading indicator
                // return const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 32),
                //   child: Center(child: CircularProgressIndicator()),
                // );
              }
            },
          ),
        ),
        // Initial load failed
        error: (err, stack) => Center(child: Text('Error occurred: $err')),
        // Initially loading (will be replaced with SkeletonView later)
        loading: () => ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) => const MovieCardSkeleton(),
        ),
      ),
    );
  }
}
