# Algorithm Learning Platform — Project State

## Project Overview

A Flutter-based educational platform for learning algorithms and data structures through interactive visualizations.

Main goals:
- Learn Flutter and Dart through a real project.
- Build an interactive algorithm visualization platform.
- Demonstrate clean architecture and maintainable code.
- Eventually make the project resume-worthy.

## Technology Stack

- Flutter
- Dart
- Riverpod 3.x
- StateNotifier
- Clean Architecture
- CustomPainter
- Git / GitHub

## Architecture

The project follows a feature-based Clean Architecture structure.

Current sorting feature:

lib/features/sorting/
├── data/
├── domain/
│   ├── sort_algo.dart
│   ├── sort_event.dart
│   └── sort_state.dart
└── presentation/
    ├── sort_controller.dart
    ├── sort_providers.dart
    ├── sorting_page.dart
    ├── sorting_algorithms_page.dart
    └── widgets/
        └── sort_bars_painter.dart

## Important Architecture Decisions

- Keep the existing architecture.
- Do not redesign the project unless there is a strong technical reason.
- Sorting algorithms generate SortEvents.
- SortController handles playback/state transitions.
- UI communicates with the controller through Riverpod providers.
- StateNotifier is intentionally being used.
- Do not migrate to Riverpod Notifier architecture unless explicitly decided.
- Avoid unnecessary dependencies.

## Current Feature: Sorting

### Completed

- Sorting algorithm selection page
- Bubble Sort
- Selection Sort
- SortEvent-based visualization architecture
- SortController
- Riverpod state management
- Sorting visualization
- CustomPainter bar visualization
- Play
- Pause
- Step Forward
- Step Backward
- Reset
- New Array
- Speed control
- Array values displayed below visualization
- Visualization currently uses 20 elements

### Available Algorithms

- Bubble Sort
- Selection Sort

## Current Phase

Phase 5 — Expanding the Sorting Algorithms

### Current Task

Continue adding basic sorting algorithms.

Next planned algorithm:
- Shift Sort

After basic sorting algorithms are completed:
- Add more searching algorithms.
- Add other data structures.
- Add trees.
- Add graphs.
- Polish UI/UX.
- Add quality-of-life features.
- Improve documentation.
- Prepare the project as a resume-worthy product.

## Development Workflow

For each feature:

1. Understand the existing architecture.
2. Make the smallest necessary change.
3. Preserve existing functionality.
4. Explain important new Flutter/Dart concepts.
5. Provide the exact file path for every code change.
6. Provide the final code/snippet for changed files.
7. Run `flutter analyze` after meaningful changes.
8. Test the feature before moving on.

## Coding Preferences

- Prefer simple, readable Dart code.
- Reuse existing architecture and components.
- Avoid unnecessary abstractions.
- Avoid unnecessary dependencies.
- Do not change working code without a reason.
- Keep algorithms separate and modular.
- Keep presentation logic out of the domain layer.

## Current Known State

The sorting flow is working.

The application can:
- Select a sorting algorithm.
- Generate a 20-element array.
- Visualize sorting.
- Play/pause execution.
- Step through events.
- Reset.
- Generate a new array.
- Change playback speed.
- Display array values.

## Important Notes

The root widget is:
AlgorithmVisualizerApp

main.dart uses ProviderScope.

Riverpod 3.x uses:
- flutter_riverpod/flutter_riverpod.dart for normal Riverpod APIs.
- flutter_riverpod/legacy.dart for StateNotifierProvider.

sort_controller.dart uses:
state_notifier/state_notifier.dart

Do not assume the project uses MyApp.

## Long-Term Roadmap

### Phase A — Algorithms
- Sorting
- Searching
- More fundamental algorithms

### Phase B — Data Structures
- Linked Lists
- Stacks
- Queues
- Trees
- Heaps
- Graphs
- Hashing

### Phase C — Visualization
- Interactive animations
- Step-by-step explanations
- Algorithm statistics
- Complexity information
- Comparison tools

### Phase D — Product Polish
- UI/UX refinement
- Navigation improvements
- Quality-of-life features
- Educational content
- Error handling
- Testing
- Documentation
- Performance improvements

### Phase E — Resume-Ready Project
- Polished UI
- Clean architecture
- Comprehensive algorithms/data structures
- Tests
- Documentation
- GitHub repository
- Screenshots/demo
- Strong README