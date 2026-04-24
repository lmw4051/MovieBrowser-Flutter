import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 💡 Remember to replace this with your actual project package name
import 'package:movie_browser/src/features/movies/presentation/movie_card.dart';

void main() {
  testWidgets('MovieCardSkeleton visual layout consistency (Golden Test)', (
    tester,
  ) async {
    // 1. Set the virtual device screen size and
    // pixel density (Simulating a standard smartphone)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    // 2. Render our skeleton placeholder
    // in a clean test environment (MaterialApp)
    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // Add some padding to make the snapshot edges look better
          body: Padding(
            padding: EdgeInsets.all(16),
            child: MovieCardSkeleton(),
          ),
        ),
      ),
    );

    // 3. Assert: Capture the MovieCardSkeleton on screen
    // and compare it with the reference image
    await expectLater(
      find.byType(MovieCardSkeleton),
      matchesGoldenFile('goldens/movie_card_skeleton.png'),
    );

    // 4. Teardown: Reset the virtual device screen settings
    // to avoid affecting other tests
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
