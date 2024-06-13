import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/bytes_converter_provider.dart';
import 'package:ztc/src/data/socket_data_store.dart';

part 'socket_data_store_provider.g.dart';

@riverpod
SocketDataStore socketDataStore(SocketDataStoreRef ref) {
  final bytesConverter = ref.read(bytesConvertedProvider);
  return SocketDataStore(bytesConverter);
}
