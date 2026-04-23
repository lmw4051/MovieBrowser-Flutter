import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast.freezed.dart';
part 'cast.g.dart';

@freezed
class Cast with _$Cast {
  const factory Cast({
    required int id,
    required String name,
    required String character,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _Cast;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

extension CastX on Cast {
  String get profileImageUrl {
    if (profilePath == null || profilePath!.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w200$profilePath';
  }
}
