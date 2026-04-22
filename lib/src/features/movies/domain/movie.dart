import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_browser/src/constants/tmdb_api_constants.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') String? releaseDate,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

// 在 movie.dart 檔案結尾加入
extension MovieX on Movie {
  /// 取得完整的海報圖片網址
  String get posterImageUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      // 回傳一個空的字串或預設的 placeholder 網址
      return '';
    }
    return '${TmdbApiConstants.imageBaseUrl}${TmdbApiConstants.posterSize}$posterPath';
  }

  /// 取得詳細頁使用的大圖網址
  String get backdropImageUrl {
    if (backdropPath == null || backdropPath!.isEmpty) return '';
    return '${TmdbApiConstants.imageBaseUrl}${TmdbApiConstants.backdropSize}$backdropPath';
  }
}
