import 'package:flutter_test/flutter_test.dart';
import 'package:hettys_shop/main.dart';

void main() {
  testWidgets('Hetty’s Shop loads initial login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HettysShopApp());
    await tester.pumpAndSettle();

    // Verify that Hetty's Shop title and Sign In elements exist.
    expect(find.text("Hetty's Shop"), findsWidgets);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
