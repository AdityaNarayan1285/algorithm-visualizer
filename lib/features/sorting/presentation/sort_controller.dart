import 'dart:async';
import 'dart:math';

import 'package:state_notifier/state_notifier.dart';

import '../domain/sort_algo.dart';
import '../domain/sort_event.dart';
import '../domain/sort_state.dart';
import '../data/algorithms/bubble_sort.dart';

class SortController extends StateNotifier<SortState> {
  Timer? _timer;

  SortAlgorithm _algorithm = BubbleSort();

  SortController() : super(SortState.initial());

  // ----------------------------------------------------------
  // Generate a new random array
  // ----------------------------------------------------------

  void generateArray(int size) {
    _stopTimer();

    final random = Random();

    final array = List.generate(
      size,
      (_) => random.nextInt(100) + 1,
    );

    state = SortState.initial().copyWith(
      array: array,
      algorithmName: _algorithm.name,
      speed: state.speed,
    );
  }

  // ----------------------------------------------------------
  // Select sorting algorithm
  // ----------------------------------------------------------

  void setAlgorithm(SortAlgorithm algorithm) {
    _stopTimer();

    _algorithm = algorithm;

    state = state.copyWith(
      algorithmName: algorithm.name,
      events: [],
      currentStep: 0,
      status: SortStatus.idle,
      activeIndexA: -1,
      activeIndexB: -1,
    );
  }

  // ----------------------------------------------------------
  // Play sorting animation
  // ----------------------------------------------------------

  void play() {
    // Don't start another timer if already running.
    if (state.status == SortStatus.running) {
      return;
    }

    // Generate events if they don't exist yet.
    if (state.events.isEmpty) {
      final events = _algorithm.execute(state.array);

      state = state.copyWith(
        events: events,
        currentStep: 0,
      );
    }

    // Nothing to play.
    if (state.events.isEmpty) {
      return;
    }

    state = state.copyWith(
      status: SortStatus.running,
    );

    _startTimer();
  }

  // ----------------------------------------------------------
  // Start timer
  // ----------------------------------------------------------

  void _startTimer() {
    _stopTimer();

    _timer = Timer.periodic(
      Duration(milliseconds: state.speed.round()),
      (_) {
        _advanceStep();
      },
    );
  }

  // ----------------------------------------------------------
  // Advance to next event
  // ----------------------------------------------------------

  void _advanceStep() {
    if (state.currentStep >= state.events.length - 1) {
      _stopTimer();

      final lastEvent = state.events.last;

      state = state.copyWith(
        currentStep: state.events.length - 1,
        status: SortStatus.completed,
        array: lastEvent.arraySnapshot,
        activeIndexA: lastEvent.indexA,
        activeIndexB: lastEvent.indexB,
      );

      return;
    }

    final nextStep = state.currentStep + 1;
    final event = state.events[nextStep];

    state = state.copyWith(
      currentStep: nextStep,
      array: event.arraySnapshot,
      activeIndexA: event.indexA,
      activeIndexB: event.indexB,
    );

    if (event.type == SortEventType.done) {
      _stopTimer();

      state = state.copyWith(
        status: SortStatus.completed,
      );
    }
  }

  // ----------------------------------------------------------
  // Pause sorting
  // ----------------------------------------------------------

  void pause() {
    if (state.status != SortStatus.running) {
      return;
    }

    _stopTimer();

    state = state.copyWith(
      status: SortStatus.paused,
    );
  }

  // ----------------------------------------------------------
  // Step forward manually
  // ----------------------------------------------------------

  void stepForward() {
    _stopTimer();

    if (state.events.isEmpty) {
      final events = _algorithm.execute(state.array);

      state = state.copyWith(
        events: events,
        currentStep: 0,
      );
    }

    if (state.currentStep >= state.events.length - 1) {
      return;
    }

    final nextStep = state.currentStep + 1;
    final event = state.events[nextStep];

    state = state.copyWith(
      currentStep: nextStep,
      array: event.arraySnapshot,
      activeIndexA: event.indexA,
      activeIndexB: event.indexB,
      status: event.type == SortEventType.done
          ? SortStatus.completed
          : SortStatus.paused,
    );
  }

  // ----------------------------------------------------------
  // Step backward manually
  // ----------------------------------------------------------

  void stepBackward() {
    _stopTimer();

    if (state.events.isEmpty) {
      return;
    }

    if (state.currentStep <= 0) {
      return;
    }

    final previousStep = state.currentStep - 1;
    final event = state.events[previousStep];

    state = state.copyWith(
      currentStep: previousStep,
      array: event.arraySnapshot,
      activeIndexA: event.indexA,
      activeIndexB: event.indexB,
      status: SortStatus.paused,
    );
  }

  // ----------------------------------------------------------
  // Reset sorting
  // ----------------------------------------------------------

  void reset() {
    _stopTimer();

    state = state.copyWith(
      currentStep: 0,
      status: SortStatus.idle,
      events: [],
      activeIndexA: -1,
      activeIndexB: -1,
    );
  }

  // ----------------------------------------------------------
  // Change animation speed
  // ----------------------------------------------------------

  void setSpeed(double milliseconds) {
    state = state.copyWith(
      speed: milliseconds,
    );

    // Restart timer with new speed if currently playing.
    if (state.status == SortStatus.running) {
      _startTimer();
    }
  }

  // ----------------------------------------------------------
  // Stop timer
  // ----------------------------------------------------------

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // ----------------------------------------------------------
  // Cleanup
  // ----------------------------------------------------------

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}