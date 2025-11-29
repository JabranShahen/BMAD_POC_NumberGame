class Puzzle {
  final String id;
  final String difficulty;
  final List<int> sequence;
  final int missingIndex;
  final List<int> options;
  final int answer;

  const Puzzle({
    required this.id,
    required this.difficulty,
    required this.sequence,
    required this.missingIndex,
    required this.options,
    required this.answer,
  });
}
