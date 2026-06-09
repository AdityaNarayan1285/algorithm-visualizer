import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Algorithm Visualizer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/sorting'),
                child: const Text('Sorting Visualizer'),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => context.go('/pathfinding'),
                child: const Text('Pathfinding Visualizer'),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => context.go('/comparison'),
                child: const Text('Algorithm Comparison'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
