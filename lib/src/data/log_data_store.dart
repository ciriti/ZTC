/// A data store class for managing log messages.
///
/// The `LogDataStore` class provides methods to add log messages and retrieve
/// the log as an unmodifiable list. It maintains an internal list of log messages
/// and allows new messages to be added to this list.
class LogDataStore {
  final List<String> _log = [];

  /// Adds a log message to the internal log list.
  ///
  /// [message] is the log message to be added.
  void addLog(String message) {
    _log.add(message);
  }

  /// Retrieves the log as an unmodifiable list.
  ///
  List<String> get log => List.unmodifiable(_log);
}
