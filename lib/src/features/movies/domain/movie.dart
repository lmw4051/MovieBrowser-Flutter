import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_browser/src/constants/tmdb_api_constants.dart';
import 'package:movie_browser/src/features/movies/domain/cast.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

Object? _readCast(Map<dynamic, dynamic> json, String key) {
  return json['credits']?['cast'];
}

@freezed
class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(readValue: _readCast) @Default([]) List<Cast> cast,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

extension MovieX on Movie {
  String get posterImageUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return '';
    }
    return '${TmdbApiConstants.imageBaseUrl}${TmdbApiConstants.posterSize}$posterPath';
  }

  String get backdropImageUrl {
    if (backdropPath == null || backdropPath!.isEmpty) return '';
    return '${TmdbApiConstants.imageBaseUrl}${TmdbApiConstants.backdropSize}$backdropPath';
  }
}
