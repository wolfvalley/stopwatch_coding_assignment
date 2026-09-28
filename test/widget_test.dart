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

        async.elapse(const Duration(milliseconds: 50));

        expect(controller.isRunning, true);
        expect(controller.elapsed.value,greaterThan(Duration.zero),
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
        expect(controller.elapsed.value,greaterThan(Duration.zero),);

        controller.pause();

        expect(controller.isPaused, true);

        final elapsedWhenPaused = controller.elapsed.value;

        async.elapse(const Duration(milliseconds: 50));

        expect(controller.elapsed.value,equals(elapsedWhenPaused));
      });
    });

    test("pressing the reset button resets the stopwatch to 0 and stops the elapsed time", () {
      fakeAsync((async) {
        expect(controller.isInitial, true);
        expect(controller.elapsed.value, Duration.zero);

        controller.start();
        async.elapse(const Duration(milliseconds: 50));

        expect(controller.isRunning, true);
        expect(controller.elapsed.value,greaterThan(Duration.zero));

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
      expect(tester.widget<Text>(elapsedFinder).data,'00:00.00',);

      /// Start the stopwatch and verify that the elapsed time begins to increase.
      await tester.tap(startButton);
      await tester.pump();

      final startInkWell = tester.widget<InkWell>(startButton);

      final pauseInkWell = tester.widget<InkWell>(pauseResumeButton);

      expect(startInkWell.onTap, isNull);
      expect(pauseInkWell.onTap, isNotNull);

      /// Pause the stopwatch and verify that the UI switches
      /// from the PAUSE action to the RESUME action.
      await tester.tap(pauseResumeButton);
      await tester.pump();

      expect(find.text('PAUSE'), findsNothing);
      expect(find.text('RESUME'), findsOneWidget);

      /// Resume the stopwatch and verify that the UI switches
      /// back from RESUME to PAUSE and the time starts increasing again.
      await tester.tap(pauseResumeButton);
      await tester.pump();

      expect(find.text("RESUME"), findsNothing);
      expect(find.text("PAUSE"), findsOneWidget);

      final pauseResumeInkwell = tester.widget<InkWell>(pauseResumeButton);
      final startInkwellAfterResume = tester.widget<InkWell>(startButton);

      expect(startInkwellAfterResume.onTap, isNull);
      expect(pauseResumeInkwell.onTap, isNotNull);

      /// Reset the stopwatch and verify that the displayed
      /// elapsed time returns to its initial value.
      await tester.tap(resetButton);
      await tester.pump();

      expect(tester.widget<Text>(elapsedFinder).data,'00:00.00');
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

      expect(tester.widget<Text>(elapsedFinder).data,'00:00.00');

      /// Verify that START is disabled while the stopwatch is running.
      await tester.tap(startFinder);
      await tester.pump();

      final startButton = tester.widget<InkWell>(startFinder);

      expect(startButton.onTap, isNull);

      /// Verify that RESET restores the initial state
      /// when the stopwatch is paused.
      await tester.tap(pauseResumeFinder);
      await tester.pump();

      await tester.tap(resetFinder);
      await tester.pump();

      expect(tester.widget<Text>(elapsedFinder).data,'00:00.00');

      expect(find.text('PAUSE'), findsOneWidget);

      /// Verify START is enabled again after reset.
      final startButtonAfterReset = tester.widget<InkWell>(startFinder);

      /// Verify PAUSE is disabled again after reset.
      final pauseButtonAfterReset = tester.widget<InkWell>(pauseResumeFinder);

      expect(startButtonAfterReset.onTap,isNotNull);

      expect(pauseButtonAfterReset.onTap,isNull);
    });
  });

  group("lap system unit tests", (){
    test("adds a lap while the stopwatch is running", () {
      fakeAsync((async) {
        controller.start();

        async.elapse(const Duration(milliseconds: 100));

        controller.addLap();

        expect(controller.laps.length, 1);

        final lap = controller.laps.first;

        expect(lap.number, 1);
        expect(lap.lapTime, greaterThan(Duration.zero));
        expect(lap.splitTime, greaterThan(Duration.zero));
        expect(lap.lapTime, lap.splitTime);
      });
    });

    test("calculates lap and split times correctly", () {
      fakeAsync((async) {
        controller.start();

        async.elapse(const Duration(milliseconds: 100));
        controller.addLap();

        async.elapse(const Duration(milliseconds: 50));

        controller.addLap();

        expect(controller.laps.length, 2);

        final latestLap = controller.laps[0];
        final previousLap = controller.laps[1];

        expect(latestLap.number, 2);
        expect(previousLap.number, 1);

        expect(latestLap.splitTime,greaterThan(previousLap.splitTime));

        expect(latestLap.lapTime,latestLap.splitTime - previousLap.splitTime);
      });
    });

    test("does not add a lap before the stopwatch is started", () {
      controller.addLap();

      expect(controller.laps, isEmpty);
    });
    test("does not add a lap while the stopwatch is paused", () {
      fakeAsync((async) {
        controller.start();

        async.elapse(const Duration(milliseconds: 50));

        controller.pause();
        controller.addLap();

        expect(controller.laps, isEmpty);
      });
    });

    test("clears all recorded laps", () {
      fakeAsync((async) {
        controller.start();

        async.elapse(const Duration(milliseconds: 50));

        controller.addLap();

        async.elapse(const Duration(milliseconds: 50));

        controller.addLap();

        expect(controller.laps.length, 2);

        controller.clearLaps();

        expect(controller.laps, isEmpty);
      });
    });
  });

  group("Lap Widget Tests", () {
    testWidgets("LAP button is disabled before the stopwatch is started", (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        final lapFinder = find.byKey(const Key('lapButton'));

        final lapButton = tester.widget<OutlinedButton>(lapFinder);

        expect(lapButton.onPressed, isNull);
      },
    );

    testWidgets(
      "LAP button is enabled while the stopwatch is running", (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        final startFinder = find.byKey(const Key('startButton'));

        final lapFinder = find.byKey(const Key('lapButton'));

        await tester.tap(startFinder);
        await tester.pump();

        final lapButton = tester.widget<OutlinedButton>(lapFinder);

        expect(lapButton.onPressed, isNotNull);
      },
    );

    testWidgets("tapping LAP displays the recorded lap", (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        final startFinder = find.byKey(const Key('startButton'));

        final lapFinder = find.byKey(const Key('lapButton'),);

        await tester.tap(startFinder);
        await tester.pump();

        await tester.tap(lapFinder);
        await tester.pump();

        expect(find.text('Lap 1'),findsOneWidget);
      },
    );

    testWidgets("multiple recorded laps are displayed in the lap sheet", (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        final startFinder = find.byKey(const Key('startButton'));

        final lapFinder = find.byKey(const Key('lapButton'));

        final lapScrollView = find.byKey(const Key('lapScrollView'));

        await tester.tap(startFinder);
        await tester.pump();

        await tester.tap(lapFinder);
        await tester.pump();

        await tester.tap(lapFinder);
        await tester.pump();

        expect(find.text('Lap 2'),findsOneWidget);

        await tester.drag(lapScrollView,const Offset(0, -300));

        await tester.pumpAndSettle();

        expect(find.text('Lap 2'),findsOneWidget);

        expect(find.text('Lap 1'),findsOneWidget);
      },
    );

    testWidgets(
      "LAP button is disabled while the stopwatch is paused",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        final startFinder = find.byKey(const Key('startButton'));

        final pauseResumeFinder = find.byKey(const Key('pauseResumeButton'));

        final lapFinder = find.byKey(const Key('lapButton'));

        await tester.tap(startFinder);
        await tester.pump();

        expect(tester.widget<OutlinedButton>(lapFinder).onPressed,isNotNull);

        await tester.tap(pauseResumeFinder);
        await tester.pump();

        expect(tester.widget<OutlinedButton>(lapFinder).onPressed,isNull);
      },
    );

    testWidgets(
      "CLEAR removes all displayed laps",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        final startFinder = find.byKey(const Key('startButton'));

        final lapFinder = find.byKey(const Key('lapButton'));

        final clearFinder = find.byKey(const Key('clearLapsButton'));

        await tester.tap(startFinder);
        await tester.pump();

        await tester.tap(lapFinder);
        await tester.pump();

        expect(find.text('Lap 1'),findsOneWidget);

        await tester.tap(clearFinder);
        await tester.pump();

        expect(find.text('Lap 1'),findsNothing);

        expect(find.text('No laps recorded'),findsOneWidget);
      },
    );
  });

  group("Analog Stopwatch Tests", (){

    testWidgets('shows digital display by default', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        expect(find.byKey(const Key('digitalStopwatchDisplay')),findsOneWidget);

        expect(find.byKey(const Key('analogStopwatchDisplay')),findsNothing);
      },
    );

    testWidgets('switches from digital to analog display and vice versa', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        await tester.tap(find.text('ANALOG'));
        await tester.pump();

        expect(find.byKey(const Key('analogStopwatchDisplay')), findsOneWidget);

        expect(find.byKey(const Key('digitalStopwatchDisplay')), findsNothing);

        await tester.tap(find.text('DIGITAL'));
        await tester.pump();

        expect(find.byKey(const Key('digitalStopwatchDisplay')), findsOneWidget);

        expect(find.byKey(const Key('analogStopwatchDisplay')), findsNothing);
      },
    );

    testWidgets('stopwatch controls remain functional in analog mode', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        await tester.tap(find.text('ANALOG'));
        await tester.pump();

        await tester.tap(find.byKey(const Key('startButton')));
        await tester.pump();

        expect(find.text('PAUSE'), findsOneWidget);

        await tester.tap(find.byKey(const Key('pauseResumeButton')));
        await tester.pump();

        expect(find.text('RESUME'), findsOneWidget);
      },
    );

    testWidgets('lap can be recorded in analog mode', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        await tester.tap(find.text('ANALOG'));
        await tester.pump();

        await tester.tap(find.byKey(const Key('startButton')));
        await tester.pump();

        final lapButton = find.byKey(const Key('lapButton'));

        expect(lapButton, findsOneWidget);

        await tester.tap(lapButton);
        await tester.pump();

        expect(find.text('Lap 1'), findsOneWidget);
      },
    );
  });
  }