import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_browser/src/common_widgets/error_message_widget.dart';
import 'package:movie_browser/src/features/movies/presentation/movie_card.dart';
import 'package:movie_browser/src/features/movies/presentation/movies_controller.dart';

class MoviesScreen extends ConsumerWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(popularMoviesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_rounded),
            tooltip: 'My Favorites',
            onPressed: () async {
              await context.push('/favorites');
            },
          ),
        ],
      ),
      body: moviesAsync.when(
        skipLoadingOnRefresh: false,
        data: (movies) => RefreshIndicator(
          onRefresh: () => ref.refresh(popularMoviesControllerProvider.future),
          child: NotificationListener<ScrollNotification>(
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
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: movies.length + 1,
              // +1 is to display the loading indicator at the bottom
              itemBuilder: (context, index) {
                if (index < movies.length) {
                  return MovieCard(
                    movie: movies[index],
                    onTap: () async {
                      await context.push('/movie/${movies[index].id}');
                    },
                  );
                } else {
                  return const MovieCardSkeleton();
                }
              },
            ),
          ),
        ),
        // Initial load failed
        error: (err, stack) => ErrorMessageWidget(
          errorMessage: err.toString(),
          onRetry: () {
            // reset old state and retrigger build function in Controller
            ref.invalidate(popularMoviesControllerProvider);
          },
        ),
        // Initially loading (will be replaced with SkeletonView later)
        loading: () => ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) => const MovieCardSkeleton(),
        ),
      ),
    );
  }
}
