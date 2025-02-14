import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/appearance_config.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

void main() {
  group(
    "Form button test",
    () {
      testWidgets(
        "enabled state",
        (widgetTester) async {
          await widgetTester.pumpWidget(
            Theme(
              data: ThemeData(primaryColor: Colors.red),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(disabled: false),
              ),
            ),
          );
          expect(find.text("Next"), findsOneWidget);
          expect(
            widgetTester
                .firstWidget<AnimatedDefaultTextStyle>(
                  find.byType(AnimatedDefaultTextStyle),
                )
                .style
                .color,
            Colors.white,
          );
          expect(
            (widgetTester
                    .firstWidget<AnimatedContainer>(
                      find.byType(AnimatedContainer),
                    )
                    .decoration as BoxDecoration)
                .color,
            Colors.red,
          );
        },
      );

      testWidgets(
        "disabled state",
        (widgetTester) async {
          await widgetTester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: FormButton(disabled: true),
            ),
          );
          expect(find.text("Next"), findsOneWidget);
          expect(
            widgetTester
                .firstWidget<AnimatedDefaultTextStyle>(
                  find.byType(AnimatedDefaultTextStyle),
                )
                .style
                .color,
            Colors.grey.shade400,
          );
        },
      );

      testWidgets(
        "disabled state in dark mode",
        (widgetTester) async {
          appearanceConfig.value = !appearanceConfig.value;
          await widgetTester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: FormButton(disabled: true),
            ),
          );
          expect(find.text("Next"), findsOneWidget);
          expect(
            (widgetTester
                    .firstWidget<AnimatedContainer>(
                      find.byType(AnimatedContainer),
                    )
                    .decoration as BoxDecoration)
                .color,
            Colors.grey.shade800,
          );
        },
      );

      testWidgets(
        "disabled state in light mode",
        (widgetTester) async {
          await widgetTester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: FormButton(disabled: true),
            ),
          );
          expect(find.text("Next"), findsOneWidget);
          expect(
            (widgetTester
                    .firstWidget<AnimatedContainer>(
                      find.byType(AnimatedContainer),
                    )
                    .decoration as BoxDecoration)
                .color,
            Colors.grey.shade300,
          );
        },
      );
    },
  );
}
