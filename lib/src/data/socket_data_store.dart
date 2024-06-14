import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/data/bytes_converter.dart';
import 'package:ztc/src/utils/ext.dart';

class SocketDataStore {
  final BytesConverter bytesConverter;
  Socket? _socket;

  SocketDataStore(this.bytesConverter);

  Future<void> connectSocket() async {
    var tempDir = await getTemporaryDirectory();
    String socketPath = "${tempDir.path}/daemon-lite";
    _socket = await Socket.connect(
      InternetAddress(socketPath, type: InternetAddressType.unix),
      0,
    );

    _socket?.listen(
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

        // completer.complete(json);
      },
      onError: (error, StackTrace stackTrace) {
        // completer.completeError(error, stackTrace);
      },
      onDone: () {},
      cancelOnError: true,
    );
  }

  Future<Map<String, dynamic>> sendRequest(
      Map<String, dynamic> requestPayload) async {
    try {
      String jsonPayload = jsonEncode(requestPayload);
      List<int> payloadBytes = utf8.encode(jsonPayload);
      int payloadSize = payloadBytes.length;
      _socket?.add(payloadSize.toBytes());
      _socket?.add(payloadBytes);

      // Read the response size
      final jsonResponse = await readBytes(_socket!);
      print('Received response: $jsonResponse');

      return jsonResponse;
    } catch (e) {
      print('Error sending request: $e');
      rethrow;
    }
  }

  void closeSocket() {
    _socket?.close();
  }

  Future<Map<String, dynamic>> readBytes(Socket socket) async {
    final completer = Completer<Map<String, dynamic>>();
    int bytesRead = 0;

    // socket.listen(
    //   (data) {
    //     // Extract the payload size from the first 8 bytes
    //     int payloadSize =
    //         data.sublist(0, 8).reversed.fold(0, (a, b) => (a << 8) + b);

    //     // Extract the JSON payload
    //     List<int> jsonPayloadBytes = data.sublist(8, 8 + payloadSize);

    //     // Decode the JSON payload
    //     String jsonString = utf8.decode(jsonPayloadBytes);
    //     Map<String, dynamic> json = jsonDecode(jsonString);

    //     print('BytesManager: $json');

    //     completer.complete(json);
    //   },
    //   onError: (error, StackTrace stackTrace) {
    //     completer.completeError(error, stackTrace);
    //   },
    //   onDone: () {
    //     if (!completer.isCompleted) {
    //       completer.completeError(Exception(
    //           'Socket closed before receiving enough data. Bytes read: $bytesRead'));
    //     }
    //   },
    //   cancelOnError: true,
    // );

    return completer.future;
  }
}
