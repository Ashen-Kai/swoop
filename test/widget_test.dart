import 'package:flutter_test/flutter_test.dart';
import 'package:swoop/app.dart';

void main() {
  testWidgets('Swoop app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SwoopApp());
    
    // Verify the Swoop wordmark is displayed
    expect(find.text('swoop'), findsOneWidget);
  });
}
