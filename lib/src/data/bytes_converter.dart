import 'dart:async';
import 'dart:convert';
import 'dart:io';

abstract class BytesConverted {
  Future<Map<String, dynamic>> readBytes(Socket socket);
}

BytesConverted buildBytesConverted() {
  return _BytesConvertedImpl();
}

class _BytesConvertedImpl implements BytesConverted {
  @override
  Future<Map<String, dynamic>> readBytes(Socket socket) async {
    final completer = Completer<Map<String, dynamic>>();
    int bytesRead = 0;

    socket.listen(
      (data) {
        // Extract the payload size from the first 8 bytes
        int payloadSize =
            data.sublist(0, 8).reversed.fold(0, (a, b) => (a << 8) + b);

        // Extract the JSON payload
        List<int> jsonPayloadBytes = data.sublist(8, 8 + payloadSize);

        // Decode the JSON payload
        String jsonString = utf8.decode(jsonPayloadBytes);
        Map<String, dynamic> json = jsonDecode(jsonString);

        print('BytesManager: $json');

        completer.complete(json);
      },
      onError: (error, StackTrace stackTrace) {
        completer.completeError(error, stackTrace);
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.completeError(Exception(
              'Socket closed before receiving enough data. Bytes read: $bytesRead'));
        }
      },
      cancelOnError: true,
    );

    return completer.future;
  }
}
