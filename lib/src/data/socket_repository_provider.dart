import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/bytes_manager_provider.dart';
import 'package:ztc/src/data/socket_repository.dart';

part 'socket_repository_provider.g.dart';

@riverpod
SocketRepository socketRepository(SocketRepositoryRef ref) {
  final bytesManager = ref.read(bytesManagerProvider);
  return SocketRepository(bytesManager);
}
