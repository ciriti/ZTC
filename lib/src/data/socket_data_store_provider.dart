import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/socket_data_store.dart';

part 'socket_data_store_provider.g.dart';

@riverpod
SocketDataStore socketDataStore(SocketDataStoreRef ref) {
  final socketDataStore = SocketDataStore();
  ref.onDispose(() {
    socketDataStore.closeSocket();
  });

  return SocketDataStore();
}
