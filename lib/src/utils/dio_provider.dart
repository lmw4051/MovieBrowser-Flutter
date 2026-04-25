import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

// Safely read the API key from --dart-define-from-file
const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      // Set reasonable timeouts to prevent the app from freezing on unstable networks
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // 1. Core Interceptor: Automatically inject the API Key
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // TMDB v3 API requires api_key as a query parameter
        options.queryParameters['api_key'] = tmdbApiKey;

        // 💡 Extension point: If you want the app to fetch
        // Traditional Chinese movie data by default,
        // you can append it globally here
        options.queryParameters['language'] = 'zh-TW';

        return handler.next(options);
      },
    ),
  );

  // 2. Log Interceptor:
  // Print detailed Request / Response in the development environment
  // This is extremely helpful for debugging!
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ),
  );

  return dio;
}
