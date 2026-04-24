import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_browser/src/common_widgets/error_message_widget.dart';
import 'package:movie_browser/src/features/movies/presentation/movie_card.dart';
import 'package:movie_browser/src/features/search/presentation/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search Movie...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            ref.read(searchControllerProvider.notifier).search(query);
          },
        ),
      ),
      body: searchState.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text('Enter keywords to start searching'),
            );
          }

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () => context.push('/movie/${movie.id}'),
              );
            },
          );
        },
        error: (err, stack) => ErrorMessageWidget(errorMessage: err.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
