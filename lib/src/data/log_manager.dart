class LogManager {
  final List<String> _log = [];

  void addLog(String message) {
    _log.add(message);
  }

  List<String> get log => List.unmodifiable(_log);
}
