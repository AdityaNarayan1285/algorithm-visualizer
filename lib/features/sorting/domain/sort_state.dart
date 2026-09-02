import 'sort_event.dart';

enum SortStatus {
  idle,
  running,
  paused,
  completed,
}

class SortState {
  final List<int> array;
  final List<SortEvent> events;
  final int currentStep;
  final SortStatus status;
  final int activeIndexA;
  final int activeIndexB;
  final List<int> sortedIndices;
  final String algorithmName;
  final double speed;

  const SortState({
    required this.array,
    required this.events,
    required this.currentStep,
    required this.status,
    required this.activeIndexA,
    required this.activeIndexB,
    required this.sortedIndices,
    required this.algorithmName,
    required this.speed,
  });

  factory SortState.initial() {
    return const SortState(
      array: [],
      events: [],
      currentStep: 0,
      status: SortStatus.idle,
      activeIndexA: -1,
      activeIndexB: -1,
      sortedIndices: [],
      algorithmName: 'Bubble Sort',
      speed: 200,
    );
  }

  SortState copyWith({
    List<int>? array,
    List<SortEvent>? events,
    int? currentStep,
    SortStatus? status,
    int? activeIndexA,
    int? activeIndexB,
    List<int>? sortedIndices,
    String? algorithmName,
    double? speed,
  }) {
    return SortState(
      array: array ?? this.array,
      events: events ?? this.events,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      activeIndexA: activeIndexA ?? this.activeIndexA,
      activeIndexB: activeIndexB ?? this.activeIndexB,
      sortedIndices: sortedIndices ?? this.sortedIndices,
      algorithmName: algorithmName ?? this.algorithmName,
      speed: speed ?? this.speed,
    );
  }
}