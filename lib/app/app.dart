import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';

class AlgorithmVisualizerApp extends StatelessWidget {
  const AlgorithmVisualizerApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
