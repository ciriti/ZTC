import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ztc/src/data/bytes_converter.dart';

part 'bytes_converter_provider.g.dart';

@riverpod
BytesConverted bytesConverted(BytesConvertedRef ref) {
  return buildBytesConverted();
}
