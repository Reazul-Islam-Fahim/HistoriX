import 'package:flutter_test/flutter_test.dart';
import 'package:historix/main.dart';

void main() {
  testWidgets('App smoke test - login screen appears', (WidgetTester tester) async {
    // Build the app with an initial route (login screen)
    await tester.pumpWidget(const HistoriXApp(initialRoute: '/login'));
    // Wait for all animations and async operations to settle
    await tester.pumpAndSettle();

    // Check that the login screen is shown (e.g., the app name "HistoriX")
    expect(find.text('HistoriX'), findsOneWidget);

    // Check that the "Welcome Back" text is present
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}