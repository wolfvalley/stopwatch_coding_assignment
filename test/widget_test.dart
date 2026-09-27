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

      final elapsedFinder = find.byKey(const Key('elapsedTime'));

      final startButton = find.byKey(const Key('startButton'));

      final pauseResumeButton = find.byKey(const Key('pauseResumeButton'));

      final resetButton = find.byKey(const Key('resetButton'));

      /// verify the stopwatch starts at zero
      expect(tester.widget<Text>(elapsedFinder).data,'00:00.000',);

      /// Start the stopwatch and verify that the elapsed time begins to increase.
      await tester.tap(startButton);

      await tester.pump(
        const Duration(milliseconds: 500),
      );

      expect(tester.widget<Text>(elapsedFinder).data,isNot('00:00.000'));

      /// Pause the stopwatch and verify that the UI switches
      /// from the PAUSE action to the RESUME action.
      await tester.tap(pauseResumeButton);
      await tester.pump();

      expect(find.text('PAUSE'), findsNothing);
      expect(find.text('RESUME'), findsOneWidget);

      final timeWhenPaused = tester.widget<Text>(elapsedFinder).data;

      /// Advance time and verify that the displayed elapsed time
      /// remains unchanged while the stopwatch is paused.
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<Text>(elapsedFinder).data,timeWhenPaused);

      /// Resume the stopwatch and verify that the UI switches
      /// back from RESUME to PAUSE and the time starts increasing again.
      await tester.tap(pauseResumeButton);
      await tester.pump();

      expect(find.text("RESUME"), findsNothing);
      expect(find.text("PAUSE"), findsOneWidget);

      final timeWhenResumed = tester.widget<Text>(elapsedFinder).data;

      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<Text>(elapsedFinder).data,isNot(timeWhenResumed));

      /// Reset the stopwatch and verify that the displayed
      /// elapsed time returns to its initial value.
      await tester.tap(resetButton);
      await tester.pump();

      expect(tester.widget<Text>(elapsedFinder).data,'00:00.000');
    });

    testWidgets("edge test cases", (WidgetTester tester) async{
      await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          )
      );

      final elapsedFinder = find.byKey(const Key('elapsedTime'));

      final startFinder = find.byKey(const Key('startButton'));

      final pauseResumeFinder = find.byKey(const Key('pauseResumeButton'));

      final resetFinder = find.byKey(const Key('resetButton'));

      /// verify the PAUSE button is disabled before the stopwatch is started
      final pauseButton = tester.widget<InkWell>(pauseResumeFinder);

      expect(pauseButton.onTap, isNull);

      expect(tester.widget<Text>(elapsedFinder).data,'00:00.000');

      await tester.tap(startFinder);

      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.widget<Text>(elapsedFinder).data,isNot('00:00.000'));

      /// Verify that START is disabled while the stopwatch is running.
      final startButton = tester.widget<InkWell>(startFinder);

      expect(startButton.onTap, isNull);

      /// Verify that the stopwatch keeps running normally.
      final timeBefore = tester.widget<Text>(elapsedFinder).data;

      await tester.pump(const Duration(milliseconds: 500));

      final timeAfter = tester.widget<Text>(elapsedFinder).data;

      expect(timeAfter,isNot(timeBefore));

      /// Verify that RESET restores the initial state
      /// when the stopwatch is paused.
      await tester.tap(find.text('START'));
      await tester.pump(
        const Duration(milliseconds: 500),
      );

      await tester.tap(pauseResumeFinder);
      await tester.pump();

      await tester.tap(resetFinder);
      await tester.pump();

      expect(tester.widget<Text>(elapsedFinder).data,'00:00.000');

      expect(find.text('PAUSE'), findsOneWidget);

      /// Verify START is enabled again after reset.
      final startButtonAfterReset = tester.widget<InkWell>(startFinder);

      /// Verify PAUSE is disabled again after reset.
      final pauseButtonAfterReset = tester.widget<InkWell>(pauseResumeFinder);

      expect(startButtonAfterReset.onTap,isNotNull);

      expect(pauseButtonAfterReset.onTap,isNull);
    });
  });
  }
/*
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  });*/
