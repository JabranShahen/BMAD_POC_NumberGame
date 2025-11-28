import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funnums/main.dart';

void main() {
  testWidgets('Puzzle displays missing number and options test', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const PuzzleGameApp());

    // Wait for first frame
    await tester.pumpAndSettle();

    // Expect the title
    expect(find.text('PuzzleGame'), findsOneWidget);

    // Expect the display sequence contains '_'
    expect(find.textContaining('_'), findsOneWidget);

    // Expect at least one answer button exists
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('Selecting an answer shows feedback text', (WidgetTester tester) async {
    await tester.pumpWidget(const PuzzleGameApp());
    await tester.pumpAndSettle();

    // Tap first answer button
    final firstButton = find.byType(ElevatedButton).first;
    await tester.tap(firstButton);
    await tester.pump();

    // Expect feedback text appears
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && (widget.data == 'Correct 🎉' || widget.data == 'Try again ❌'),
      ),
      findsOneWidget,
    );
  });
}
