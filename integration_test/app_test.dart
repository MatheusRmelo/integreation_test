// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ideast/main.dart';
import 'package:flutter/material.dart';
import 'package:ideast/model/idea_model.dart';
import 'package:provider/provider.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

Future<void> logout(WidgetTester tester) async {
  await addDelay(8000);

  await tester.tap(find.byKey(const ValueKey('LogoutKey')));

  await addDelay(8000);

  tester.printToConsole('Login screen opens');

  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;
  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  group('end-to-end test', () {
    final timeBasedEmail = DateTime.now().microsecondsSinceEpoch.toString() + '@test.com';

    testWidgets('Autentication Testing', (WidgetTester tester) async {
      await Firebase.initializeApp();

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextButton));

      tester.printToConsole('SignUp Screen opens');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('emailSignUpField')), timeBasedEmail);

      await tester.enterText(find.byKey(const ValueKey('passwordSignUpField')), 'test123');
      await tester.enterText(find.byKey(const ValueKey('confirmPasswordSignUpField')), 'test123');

      await tester.tap(find.byType(ElevatedButton));
      await addDelay(24000);

      await tester.pumpAndSettle();

      expect(find.text('Ideas'), findsOneWidget);

      await logout(tester);
    });

    testWidgets('Modifying Features test', (WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await addDelay(10000);

      await tester.enterText(find.byKey(const ValueKey('emailLoginField')), timeBasedEmail);
      await tester.enterText(find.byKey(const ValueKey('passwordLoginField')), 'test123');
      await tester.tap(find.byType(ElevatedButton));

      await addDelay(18000);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await addDelay(2000);
      tester.printToConsole('New Idea screen opens');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('newIdeaField')), 'New Book');
      await tester.enterText(find.byKey(const ValueKey('inspirationField')), 'Elon');

      await addDelay(1000);
      await tester.ensureVisible(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));

      await addDelay(4000);
      tester.printToConsole('New Idea added!');

      await tester.pumpAndSettle();
      await addDelay(1000);

      final state = tester.state(find.byType(Scaffold));

      final title = Provider.of<IdeasModel>(state.context, listen: false).getAllIdeas[0].title;
      final tempTitle = title!;

      await addDelay(1000);

      await tester.drag(find.byKey(ValueKey(title.toString())), const Offset(-600, 0));

      await addDelay(5000);

      expect(find.text(tempTitle), findsNothing);
      await logout(tester);
    });
  });
}
