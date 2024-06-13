import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/log_manager.dart';

part 'log_manager_provider.g.dart';

@riverpod
LogManager logManager(LogManagerRef ref) {
  return LogManager();
}
