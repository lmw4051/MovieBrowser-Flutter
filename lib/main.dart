import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_browser/src/routing/app_router.dart';

void main() async {
  // 💡 Ensure Flutter bindings are initialized
  // (since we are performing async operations before runApp)
  WidgetsFlutterBinding.ensureInitialized();

  // 💡 Initialize Hive and open a box named 'favorites'
  // We specify the type as <String>
  // because we will store the Movie objects as JSON strings
  await Hive.initFlutter();
  await Hive.openBox<String>('favorites');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
    );
  }
}
