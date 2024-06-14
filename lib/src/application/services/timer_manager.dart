import 'dart:async';

class TimerManager {
  Timer? _timer;
  final int duration;

  TimerManager({required this.duration});

  void startLogging(void Function() callback) {
    callback();
    _timer = Timer.periodic(Duration(seconds: duration), (timer) {
      callback();
    });
  }

  void stopLogging() {
    _timer?.cancel();
  }
}
