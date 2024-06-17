import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/log_data_store.dart';

part 'log_data_store_provider.g.dart';

/// Provides an instance of `LogDataStore` for dependency injection using Riverpod.
@riverpod
LogDataStore logDataStore(LogDataStoreRef ref) {
  return LogDataStore();
}
