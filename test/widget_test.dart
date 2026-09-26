// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch_coding_assignment/controllers/stopwatch_controller.dart';
import 'package:stopwatch_coding_assignment/screens/home_screen.dart';

void main() {
  late StopwatchController controller;

  setUp(() {
    controller = StopwatchController();
  });

  tearDown((){
    controller.dispose();
  });

  group("StopwatchController Unit Tests", (){
    test("starts the stopwatch and the elapsed time increases over time", () {
      expect(controller.elapsed.value, Duration.zero);
      expect(controller.isInitial, true);

      fakeAsync((async) {
        controller.start();

        async.elapse(
          const Duration(milliseconds: 50),
        );

        expect(controller.isRunning, true);
        expect(
          controller.elapsed.value,
          greaterThan(Duration.zero),
        );
      });
    });


    test("pressing the pause button pauses the stopwatch and the elapsed time stops increasing", () {
      fakeAsync((async) {
        expect(controller.isInitial, true);
        expect(controller.elapsed.value, Duration.zero);

        controller.start();
        async.elapse(const Duration(milliseconds: 50));

        expect(controller.isRunning, true);
        expect(
          controller.elapsed.value,
          greaterThan(Duration.zero),
        );

        controller.pause();

        expect(controller.isPaused, true);

        final elapsedWhenPaused = controller.elapsed.value;

        async.elapse(const Duration(milliseconds: 50));

        expect(
          controller.elapsed.value,
          equals(elapsedWhenPaused),
        );
      });
    });

    test("pressing the reset button resets the stopwatch to 0 and stops the elapsed time", () {
      fakeAsync((async) {
        expect(controller.isInitial, true);
        expect(controller.elapsed.value, Duration.zero);

        controller.start();
        async.elapse(const Duration(milliseconds: 50));

        expect(controller.isRunning, true);
        expect(
          controller.elapsed.value,
          greaterThan(Duration.zero),
        );

        controller.reset();

        expect(controller.isInitial, true);
        expect(controller.elapsed.value, Duration.zero);

        async.elapse(const Duration(milliseconds: 50));

        expect(controller.elapsed.value, Duration.zero);
        expect(controller.isInitial, true);
      });
    });
  });

  group("HomeScreen Widget Tests", (){
    testWidgets("user can start, pause, resume and reset the stopwatch", (WidgetTester tester) async{
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        )
      );

      /// verify the stopwatch starts at zero after the render of HomeScreen
      expect(find.text("00:00.000"), findsOneWidget);

      /// Start the stopwatch and verify that the elapsed time begins to increase.
      await tester.tap(find.text('START'));

      await tester.pump( const Duration(milliseconds: 500));

      expect(find.text('00:00.000'), findsNothing);

      /// Pause the stopwatch and verify that the UI switches
      /// from the PAUSE action to the RESUME action.
      await tester.tap(find.text('PAUSE'));
      await tester.pump();

      expect(find.text("PAUSE"), findsNothing);
      expect(find.text("RESUME"), findsOneWidget);

      final elapsedFinder = find.byKey(const Key('elapsedTime'));

      final timeText = tester.widget<Text>(elapsedFinder).data;

      /// Advance time and verify that the displayed elapsed time
      /// remains unchanged while the stopwatch is paused.
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<Text>(elapsedFinder).data, timeText);


      /// Resume the stopwatch and verify that the UI switches
      /// back from RESUME to PAUSE and the time starts increasing again.
      await tester.tap(find.text("RESUME"));
      await tester.pump();

      expect(find.text("RESUME"), findsNothing);
      expect(find.text("PAUSE"), findsOneWidget);

      final timeWhenResumed = tester.widget<Text>(elapsedFinder).data;

      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<Text>(elapsedFinder).data,isNot(timeWhenResumed));

      /// Reset the stopwatch and verify that the displayed
      /// elapsed time returns to its initial value.
      expect(find.text("00:00.000"), findsNothing);
      await tester.tap(find.text("RESET"));

      await tester.pump();

      expect(find.text("00:00.000"), findsOneWidget);

    });
    testWidgets("edge cases", (WidgetTester tester) async{
      await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          )
      );

      final elapsedFinder = find.byKey(const Key('elapsedTime'));

      /// verify the PAUSE button is disabled before the stopwatch is started
      final pauseButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'PAUSE'));

      expect(pauseButton.onPressed, isNull);
      expect(find.text("00:00.000"), findsOneWidget);

      await tester.tap(find.text("START"));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text("00:00.000"), findsNothing);

      /// Verify that START is disabled while the stopwatch is running.
      final startButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'START'),
      );

      expect(startButton.onPressed, isNull);

      /// Verify that the stopwatch keeps running normally.
      final timeBefore = tester.widget<Text>(
        elapsedFinder,
      ).data;

      await tester.pump(
        const Duration(milliseconds: 500),
      );

      final timeAfter = tester.widget<Text>(
        elapsedFinder,
      ).data;

      expect(timeAfter, isNot(timeBefore));

      /// Verify that RESET restores the initial state
      /// when the stopwatch is paused.
      await tester.tap(find.text('START'));
      await tester.pump(
        const Duration(milliseconds: 500),
      );

      await tester.tap(find.text('PAUSE'));
      await tester.pump();

      expect(find.text('RESUME'), findsOneWidget);

      await tester.tap(find.text('RESET'));
      await tester.pump();

      expect(find.text('00:00.000'), findsOneWidget);
      expect(find.text('PAUSE'), findsOneWidget);

      final startButtonAfterReset = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'START'),
      );

      final pauseButtonAfterReset = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'PAUSE'),
      );

      expect(startButtonAfterReset.onPressed, isNotNull);
      expect(pauseButtonAfterReset.onPressed, isNull);
    });
  });
  }
/*
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  });*/
