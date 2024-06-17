import 'dart:async';

/// A class for managing periodic timer events.
///
/// The `TimerManager` class allows you to start and stop a timer that periodically
/// executes a callback function. This is useful for tasks that need to run at
/// regular intervals, such as logging or updating a UI.
class TimerManager {
  Timer? _timer;
  final int duration;

  TimerManager({required this.duration});

  /// Starts the timer and executes the callback at the specified interval.
  ///
  /// [callback] is the function to be executed periodically.
  void startLogging(void Function() callback) {
    _timer = Timer.periodic(Duration(seconds: duration), (timer) {
      callback();
    });
  }

  /// Stops the timer and cancels any scheduled callback executions.
  void stopLogging() {
    _timer?.cancel();
  }
}
