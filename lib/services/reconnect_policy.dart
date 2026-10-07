class ReconnectPolicy {
  final List<Duration> _delays = const [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
  ];

  Duration delayForAttempt(int attempt) {
    if (attempt <= 0) {
      return _delays.first;
    }

    final index = attempt - 1;

    if (index >= _delays.length) {
      return _delays.last;
    }

    return _delays[index];
  }

  void reset() {}
}
