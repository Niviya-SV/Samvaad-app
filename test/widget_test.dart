import 'package:flutter_test/flutter_test.dart';
import 'package:samvaad/main.dart';

void main() {
  testWidgets('Samvaad welcome screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SamvaadApp());

    expect(find.text('SAMVAAD'), findsOneWidget);
    expect(find.text('Begin Learning'), findsOneWidget);
  });
}