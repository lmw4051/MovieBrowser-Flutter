import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_browser/src/features/movies/domain/movie.dart';

part 'tmdb_movies_response.freezed.dart';
part 'tmdb_movies_response.g.dart';

@freezed
class TmdbMoviesResponse with _$TmdbMoviesResponse {
  factory TmdbMoviesResponse({
    required int page,
    required List<Movie> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _TmdbMoviesResponse;

  factory TmdbMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$TmdbMoviesResponseFromJson(json);
}
