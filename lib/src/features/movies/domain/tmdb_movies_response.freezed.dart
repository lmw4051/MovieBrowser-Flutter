// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmdb_movies_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TmdbMoviesResponse _$TmdbMoviesResponseFromJson(Map<String, dynamic> json) {
  return _TmdbMoviesResponse.fromJson(json);
}

/// @nodoc
mixin _$TmdbMoviesResponse {
  int get page => throw _privateConstructorUsedError;
  List<Movie> get results => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_results')
  int get totalResults => throw _privateConstructorUsedError;

  /// Serializes this TmdbMoviesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TmdbMoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TmdbMoviesResponseCopyWith<TmdbMoviesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TmdbMoviesResponseCopyWith<$Res> {
  factory $TmdbMoviesResponseCopyWith(
    TmdbMoviesResponse value,
    $Res Function(TmdbMoviesResponse) then,
  ) = _$TmdbMoviesResponseCopyWithImpl<$Res, TmdbMoviesResponse>;
  @useResult
  $Res call({
    int page,
    List<Movie> results,
    @JsonKey(name: 'total_pages') int totalPages,
    @JsonKey(name: 'total_results') int totalResults,
  });
}

/// @nodoc
class _$TmdbMoviesResponseCopyWithImpl<$Res, $Val extends TmdbMoviesResponse>
    implements $TmdbMoviesResponseCopyWith<$Res> {
  _$TmdbMoviesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TmdbMoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? results = null,
    Object? totalPages = null,
    Object? totalResults = null,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            results: null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                      as List<Movie>,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            totalResults: null == totalResults
                ? _value.totalResults
                : totalResults // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TmdbMoviesResponseImplCopyWith<$Res>
    implements $TmdbMoviesResponseCopyWith<$Res> {
  factory _$$TmdbMoviesResponseImplCopyWith(
    _$TmdbMoviesResponseImpl value,
    $Res Function(_$TmdbMoviesResponseImpl) then,
  ) = __$$TmdbMoviesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    List<Movie> results,
    @JsonKey(name: 'total_pages') int totalPages,
    @JsonKey(name: 'total_results') int totalResults,
  });
}

/// @nodoc
class __$$TmdbMoviesResponseImplCopyWithImpl<$Res>
    extends _$TmdbMoviesResponseCopyWithImpl<$Res, _$TmdbMoviesResponseImpl>
    implements _$$TmdbMoviesResponseImplCopyWith<$Res> {
  __$$TmdbMoviesResponseImplCopyWithImpl(
    _$TmdbMoviesResponseImpl _value,
    $Res Function(_$TmdbMoviesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TmdbMoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? results = null,
    Object? totalPages = null,
    Object? totalResults = null,
  }) {
    return _then(
      _$TmdbMoviesResponseImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        results: null == results
            ? _value._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<Movie>,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        totalResults: null == totalResults
            ? _value.totalResults
            : totalResults // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TmdbMoviesResponseImpl implements _TmdbMoviesResponse {
  _$TmdbMoviesResponseImpl({
    required this.page,
    required final List<Movie> results,
    @JsonKey(name: 'total_pages') required this.totalPages,
    @JsonKey(name: 'total_results') required this.totalResults,
  }) : _results = results;

  factory _$TmdbMoviesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TmdbMoviesResponseImplFromJson(json);

  @override
  final int page;
  final List<Movie> _results;
  @override
  List<Movie> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'total_results')
  final int totalResults;

  @override
  String toString() {
    return 'TmdbMoviesResponse(page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TmdbMoviesResponseImpl &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    const DeepCollectionEquality().hash(_results),
    totalPages,
    totalResults,
  );

  /// Create a copy of TmdbMoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TmdbMoviesResponseImplCopyWith<_$TmdbMoviesResponseImpl> get copyWith =>
      __$$TmdbMoviesResponseImplCopyWithImpl<_$TmdbMoviesResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TmdbMoviesResponseImplToJson(this);
  }
}

abstract class _TmdbMoviesResponse implements TmdbMoviesResponse {
  factory _TmdbMoviesResponse({
    required final int page,
    required final List<Movie> results,
    @JsonKey(name: 'total_pages') required final int totalPages,
    @JsonKey(name: 'total_results') required final int totalResults,
  }) = _$TmdbMoviesResponseImpl;

  factory _TmdbMoviesResponse.fromJson(Map<String, dynamic> json) =
      _$TmdbMoviesResponseImpl.fromJson;

  @override
  int get page;
  @override
  List<Movie> get results;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(name: 'total_results')
  int get totalResults;

  /// Create a copy of TmdbMoviesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TmdbMoviesResponseImplCopyWith<_$TmdbMoviesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
