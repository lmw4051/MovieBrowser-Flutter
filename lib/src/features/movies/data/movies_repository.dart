import 'package:dio/dio.dart';
import 'package:movie_browser/src/features/movies/domain/movie_exception.dart';
import 'package:movie_browser/src/features/movies/domain/tmdb_movies_response.dart';
import 'package:movie_browser/src/utils/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_repository.g.dart';

class MoviesRepository {
  const MoviesRepository(this._dio);
  final Dio _dio;

  Future<TmdbMoviesResponse> getPopularMovies({int page = 1}) async {
    try {
      // 1. Send the request (the interceptor has already injected the API Key)
      final response = await _dio.get<Map<String, dynamic>>(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      // 2. Successfully retrieved data, parse JSON into the Freezed model
      return TmdbMoviesResponse.fromJson(response.data!);
    } on DioException catch (e) {
      // 3. Error interception and mapping
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const MovieException.noInternet();
      }

      final statusCode = e.response?.statusCode;

      if (statusCode == 404) {
        throw const MovieException.notFound();
      }

      if (statusCode != null && e.response!.statusCode! >= 500) {
        throw const MovieException.serverError();
      }

      // Other Dio errors
      throw MovieException.unknown(e.message);
    } catch (e) {
      // Catch JSON parsing failures or other non-Dio errors
      throw MovieException.unknown(e.toString());
    }
  }
}

// 4. Create a Riverpod Provider to be injected into the UI layer or other services
@riverpod
MoviesRepository moviesRepository(MoviesRepositoryRef ref) {
  // Retrieve the previously configured Dio instance via ref.watch
  return MoviesRepository(ref.watch(dioProvider));
}
