import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/src/features/movies/data/movies_repository.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';
import 'package:movie_browser/src/features/movies/domain/movie_exception.dart';

// 1. Create a mock Dio class
class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MoviesRepository repository;

  // setUp runs before each test() to ensure a clean testing environment
  setUp(() {
    mockDio = MockDio();
    // Inject the mock Dio instance!
    repository = MoviesRepository(mockDio);
  });

  group(
    'MoviesRepository Unit Tests',
    () {
      // Prepare mock JSON data for testing
      final mockMovieJson = {
        'id': 999,
        'title': 'Mock Testing Master',
        'overview': 'Learn how to write stable tests',
        'vote_average': 10.0,
      };

      test(
        'Should return the correct Movie entity when data is fetched successfully',
        () async {
          // --- Arrange ---
          // Stubbing the MockDio: When get('/movie/999') is called with any queryParameters,
          // return HTTP 200 along with our mock JSON data.
          when(
            () => mockDio.get<Map<String, dynamic>>(
              '/movie/999',
              queryParameters: any(named: 'queryParameters'),
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/movie/999'),
              statusCode: 200,
              data: mockMovieJson,
            ),
          );

          // --- Act ---
          final result = await repository.getMovie(999);

          // --- Assert ---
          expect(result, isA<Movie>());
          expect(result.id, 999);
          expect(result.title, 'Mock Testing Master');

          // Verify that the API was actually called exactly once
          verify(
            () => mockDio.get<Map<String, dynamic>>(
              '/movie/999',
              queryParameters: any(named: 'queryParameters'),
            ),
          ).called(1);
        },
      );

      test(
        'Should throw MovieException.notFound when encountering a 404 error',
        () async {
          // --- Arrange ---
          // Simulate Dio throwing a 404 Not Found error
          when(
            () => mockDio.get<Map<String, dynamic>>(
              '/movie/123',
              queryParameters: any(named: 'queryParameters'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/movie/123'),
              response: Response(
                requestOptions: RequestOptions(path: '/movie/123'),
                statusCode: 404,
              ),
            ),
          );

          // --- Act & Assert ---
          // Verify that calling this code actually throws the expected Exception
          expect(
            () => repository.getMovie(123),
            throwsA(
              isA<MovieException>().having(
                (e) => e
                    .toString(), // Assuming your Exception has a custom toString or identifiable property
                'description',
                contains(
                  'notFound',
                ), // Adjust this based on your actual Exception implementation
              ),
            ),
          );
        },
      );
    },
  );
}
