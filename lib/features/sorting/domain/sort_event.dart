enum SortEventType {
  comparison,
  swap,
  shift,
  insert,
  mark,
  unmark,
  done,
}

class SortEvent {
  final SortEventType type;
  final int indexA;
  final int indexB;
  final List<int> arraySnapshot;

  const SortEvent({
    required this.type,
    required this.indexA,
    required this.indexB,
    required this.arraySnapshot,
  });
}