import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:morphanimal/main.dart';

void main() {
  testWidgets('Smoke test for MorphanimalApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MorphanimalApp()));

    // Verify that our app displays the setup ok text
    expect(find.text('Morphanimal Setup OK'), findsOneWidget);
  });
}
