import 'package:go_router/go_router.dart';

import '../features/comparison/presentation/comparison_page.dart';
import '../features/pathfinding/presentation/pathfinding_page.dart';
import '../features/sorting/presentation/sorting_page.dart';
import '../features/home/presentation/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),

    GoRoute(path: '/sorting', builder: (context, state) => const SortingPage()),

    GoRoute(
      path: '/pathfinding',
      builder: (context, state) => const PathfindingPage(),
    ),

    GoRoute(
      path: '/comparison',
      builder: (context, state) => const ComparisonPage(),
    ),
  ],
);
