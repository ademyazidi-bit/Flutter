import 'package:flutter_test/flutter_test.dart';

import 'package:tel_app/main.dart';

void main() {
  testWidgets('opens login and navigates to signup', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Connexion'), findsOneWidget);
    await tester.tap(find.text('Créer un compte'));
    await tester.pumpAndSettle();

    expect(find.text('Inscription'), findsOneWidget);
  });
}
