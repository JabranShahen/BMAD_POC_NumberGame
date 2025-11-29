class SessionStats {
  final String mode;
  final int score;
  final Map<String, int> bestPerMode;
  final Map<String, int> solvedCounts;
  final List<HistoryEntry> history;

  const SessionStats({
    required this.mode,
    required this.score,
    required this.bestPerMode,
    required this.solvedCounts,
    required this.history,
  });
}

class HistoryEntry {
  final String mode;
  final int score;
  final DateTime timestamp;

  const HistoryEntry({
    required this.mode,
    required this.score,
    required this.timestamp,
  });
}
