import 'package:flutter_test/flutter_test.dart';

import 'package:video/main.dart';

void main() {
  testWidgets('shows the media studio playlist', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Media Studio'), findsOneWidget);
    expect(find.text('Playlist'), findsOneWidget);
    expect(find.text('Bee Sample'), findsWidgets);
  });
}
