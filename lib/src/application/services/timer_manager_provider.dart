import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/application/services/timer_manager.dart';

part 'timer_manager_provider.g.dart';

@riverpod
TimerManager timerManager(TimerManagerRef ref) {
  return TimerManager(duration: 5);
}
