import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/algorithms/bubble_sort.dart';
import '../data/algorithms/selection_sort.dart';
import 'sort_providers.dart';
import 'sorting_page.dart';

class SortingAlgorithmsPage extends ConsumerWidget {
  const SortingAlgorithmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Algorithms'),
      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _AlgorithmCard(
            name: 'Bubble Sort',
            description:
                'Compare adjacent elements and swap them.',
            bestTime: 'O(n)',
            averageTime: 'O(n²)',
            worstTime: 'O(n²)',
            spaceComplexity: 'O(1)',
            onTap: () {
              ref
                  .read(sortControllerProvider.notifier)
                  .setAlgorithm(BubbleSort());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SortingPage(),
                ),
              );
            },
          ),

          _AlgorithmCard(
            name: 'Selection Sort',
            description:
                'Repeatedly select the smallest element.',
            bestTime: 'O(n²)',
            averageTime: 'O(n²)',
            worstTime: 'O(n²)',
            spaceComplexity: 'O(1)',
            onTap: () {
              ref
                  .read(sortControllerProvider.notifier)
                  .setAlgorithm(SelectionSort());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SortingPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AlgorithmCard extends StatelessWidget {
  final String name;
  final String description;

  final String bestTime;
  final String averageTime;
  final String worstTime;
  final String spaceComplexity;

  final VoidCallback onTap;

  const _AlgorithmCard({
    required this.name,
    required this.description,
    required this.bestTime,
    required this.averageTime,
    required this.worstTime,
    required this.spaceComplexity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.bar_chart,
                size: 40,
              ),

              const SizedBox(height: 16),

              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(description),

              const SizedBox(height: 16),

              const Text(
                'Time Complexity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text('Best: $bestTime'),
              Text('Average: $averageTime'),
              Text('Worst: $worstTime'),

              const SizedBox(height: 12),

              const Text(
                'Space Complexity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(spaceComplexity),

              const Spacer(),

              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}