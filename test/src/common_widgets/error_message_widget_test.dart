import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser/src/common_widgets/error_message_widget.dart';

void main() {
  testWidgets(
    'ErrorMessageWidget should display the correct message and trigger the retry button',
    (tester) async {
      // 1. Arrange: Create a variable to track if the button has been pressed
      var isRetryPressed = false;

      // Render our widget on the virtual canvas
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorMessageWidget(
              errorMessage: 'Server exploded',
              onRetry: () {
                isRetryPressed = true;
              },
            ),
          ),
        ),
      );

      // 2. Assert: Verify that our error message actually appears on the screen
      expect(find.text('Server exploded'), findsOneWidget);
      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.text('Retry Again'), findsOneWidget);

      // 3. Act: Simulate the user tapping the "Retry" button
      await tester.tap(find.byType(ElevatedButton));

      // 💡 Calling pump is essential; it represents "advancing one frame,"
      // allowing Flutter time to process the tap event.
      await tester.pump();

      // 4. Assert: Verify that our callback was actually triggered!
      expect(isRetryPressed, isTrue);
    },
  );
}
