import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';

void main() {
  // Use group to wrap related tests together for better report readability
  group(
    'Movie Model Unit Tests',
    () {
      test(
        '1. Should correctly parse Movie entity and cast from standard TMDB JSON',
        () {
          // --- Arrange (Prepare data) ---
          final mockJson = <String, dynamic>{
            'id': 123,
            'title': 'Dark Knight',
            'overview': 'Superhero',
            'vote_average': 9.8,
            'release_date': '2026-05-01',
            'poster_path': '/poster.jpg',
            'backdrop_path': '/backdrop.jpg',
            'credits': {
              'cast': [
                {
                  'id': 1,
                  'name': 'Christian Bale',
                  'character': 'Bat Man',
                  'profile_path': '/ChristianBale.jpg',
                },
              ],
            },
          };

          // --- Act (Execute action) ---
          final movie = Movie.fromJson(mockJson);

          // --- Assert (Verify assertions) ---
          // Verify basic fields are mapped correctly
          expect(movie.id, 123);
          expect(movie.title, 'Dark Knight');
          expect(movie.voteAverage, 9.8);

          // 💡 Verify our previously fixed "nested parsing" logic works perfectly
          expect(movie.cast.length, 1);
          expect(movie.cast.first.name, 'Christian Bale');
          expect(movie.cast.first.character, 'Bat Man');
        },
      );

      test(
        '2. Should provide an empty array and avoid crashing when API does not return credits.cast',
        () {
          // --- Arrange ---
          // Simulate an incomplete JSON response
          final mockIncompleteJson = <String, dynamic>{
            'id': 456,
            'title': 'The Castless Documentary',
            'overview': '',
            'vote_average': 0.0,
          };

          // --- Act ---
          final movie = Movie.fromJson(mockIncompleteJson);

          // --- Assert ---
          expect(movie.id, 456);
          // 💡 Ssed @Default([]) in the Model; this verifies
          // that the protection works as intended
          expect(movie.cast, isEmpty);
        },
      );
    },
  );
}
