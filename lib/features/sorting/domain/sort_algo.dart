import 'sort_event.dart';

abstract class SortAlgorithm {
  String get name;

  List<SortEvent> execute(List<int> array);
}