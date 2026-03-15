import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_survey/example/example_functions.dart';

void main() {
  group('Context KERAK EMAS — oddiy funksiyalar', () {
    test('addNumbers — to\'g\'ridan-to\'g\'ri chaqiramiz, context yo\'q', () {
      expect(addNumbers(2, 3), 5);
      expect(addNumbers(-1, 1), 0);
    });

    test('isValidEmail — faqat string beramiz, context yo\'q', () {
      expect(isValidEmail('test@mail.com'), true);
      expect(isValidEmail('invalid'), false);
      expect(isValidEmail(''), false);
    });
  });

  group('Context KERAK — BuildContext ishlatadigan funksiya', () {
    testWidgets('getThemeBrightness — context olish uchun widget tree kerak',
        (WidgetTester tester) async {
      // Context olish uchun MaterialApp ichida widget "pump" qilamiz
      final brightness = Brightness.dark;
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(getThemeBrightness(capturedContext), Brightness.dark);
    });

    testWidgets('getThemeBrightness — light theme bilan',
        (WidgetTester tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(getThemeBrightness(capturedContext), Brightness.light);
    });
  });
}
