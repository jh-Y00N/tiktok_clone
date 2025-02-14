import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUp(
    () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAuth.instance.signOut();
    },
  ); // run before the test starts

  testWidgets(
    "create account flow",
    (widgetTester) async {
      await widgetTester.pumpWidget(
        ProviderScope(
          child: TikTokApp(),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.text("Sign up for TikTok"), findsOneWidget);
      final logIn = find.text("Log in");
      expect(logIn, findsOneWidget);
      await widgetTester.tap(logIn);

      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));

      final signUp = find.text("Sign up");
      expect(signUp, findsOneWidget);
      await widgetTester.tap(signUp);

      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));

      final email = find.text("Use email & password");
      expect(email, findsOneWidget);
      await widgetTester.tap(email);
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));

      final usernameInput = find.byType(TextField).first;
      await widgetTester.enterText(usernameInput, "test");
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));
      await widgetTester.tap(find.text("Next"));

      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));

      final emailInput = find.byType(TextField).first;
      await widgetTester.enterText(emailInput, "test@test.com");
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));
      await widgetTester.tap(find.text("Next"));

      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));

      final pwInput = find.byType(TextField).first;
      await widgetTester.enterText(pwInput, "testtest");
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));
      await widgetTester.tap(find.text("Next"));

      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(Duration(seconds: 4));

      await widgetTester.tap(find.text("Next"));
      await widgetTester.pumpAndSettle(Duration(seconds: 4));
    },
  );

  tearDown(
    () {},
  ); // run when the test is finished
}
