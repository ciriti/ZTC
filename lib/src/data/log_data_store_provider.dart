import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/log_data_store.dart';

part 'log_data_store_provider.g.dart';

@riverpod
LogDataStore logDataStore(LogDataStoreRef ref) {
  return LogDataStore();
}
