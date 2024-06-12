import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/bytes_manager.dart';

part 'bytes_manager_provider.g.dart';

@riverpod
BytesManager bytesManager(BytesManagerRef ref) {
  return buildBytesManager();
}
