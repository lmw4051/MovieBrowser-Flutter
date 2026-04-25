import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_browser/main.dart' as app;
import 'package:movie_browser/src/features/movies/presentation/movie_card.dart';

void main() {
  // 1. Initialize the integration test bindings
  // (Allows the test to control the physical device/emulator)
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'End-to-End Scenario: Scrolling from Home and navigating to Detail page',
    (tester) async {
      // 2. Launch the entire app!
      app.main();

      // Wait for all animations and API calls to complete until the UI is stable (Settle)
      await tester.pumpAndSettle();

      // 3. Verify that we have arrived at the Home Screen (MovieCards should be present)
      expect(find.byType(MovieCard), findsWidgets);

      // 4. Find the first movie card on the screen and tap it
      final firstMovieCard = find.byType(MovieCard).first;
      await tester.tap(firstMovieCard);

      // Wait for the navigation animation to complete and detail data to load
      await tester.pumpAndSettle();

      // 5. Verify successful navigation to the Detail Page
      // (Check for specific text or widgets)
      expect(find.text('Synopsis'), findsOneWidget);
      expect(find.text('Main Cast'), findsOneWidget);

      // (Optional) Pause for 2 seconds to visually observe the automated click process
      await Future.delayed(const Duration(seconds: 2));
    },
  );
}
