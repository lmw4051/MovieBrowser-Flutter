import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_exception.freezed.dart';

// Implement the Exception interface so it can be thrown
@freezed
class MovieException with _$MovieException implements Exception {
  /// No internet connection or timeout
  const factory MovieException.noInternet() = _NoInternet;

  /// API returned 404 Not Found
  const factory MovieException.notFound() = _NotFound;

  /// Server-side error (50x)
  const factory MovieException.serverError() = _ServerError;

  /// Unknown error (catches other unexpected situations)
  const factory MovieException.unknown([String? message]) = _Unknown;
}
