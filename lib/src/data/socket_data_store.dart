import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';
import 'package:ztc/src/utils/ext.dart';

class SocketDataStore {
  Socket? _socket;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  SocketDataStore();

  Future<void> connectSocket(
    Function(String) success,
    Function(String) failure,
  ) async {
    try {
      var tempDir = await getTemporaryDirectory();
      String socketPath = "${tempDir.path}/daemon-lite";
      _socket = await Socket.connect(
        InternetAddress(socketPath, type: InternetAddressType.unix),
        0,
      );

      _socket?.listen(
        (data) {
          try {
            // Extract the payload size from the first 8 bytes
            int payloadSize =
                data.sublist(0, 8).reversed.fold(0, (a, b) => (a << 8) + b);

            // Extract the JSON payload
            List<int> jsonPayloadBytes = data.sublist(8, 8 + payloadSize);

            // Decode the JSON payload
            String jsonString = utf8.decode(jsonPayloadBytes);
            Map<String, dynamic> json = jsonDecode(jsonString);

            print('BytesManager: $json');
            _isConnected = true;
            success(jsonString);
          } catch (e) {
            _isConnected = false;
            print(e.toString());
          }
        },
        onError: (error, StackTrace stackTrace) {
          failure(error.toString());
          closeSocket();
          _isConnected = false;
        },
        onDone: () {
          closeSocket();
          _isConnected = false;
        },
        cancelOnError: true,
      );
    } catch (e) {
      failure(e.toString());
      closeSocket();
      _isConnected = false;
    }
  }

  Future<void> sendRequest(Map<String, dynamic> requestPayload) async {
    try {
      String jsonPayload = jsonEncode(requestPayload);
      List<int> payloadBytes = utf8.encode(jsonPayload);
      int payloadSize = payloadBytes.length;
      _socket?.add(payloadSize.toBytes());
      _socket?.add(payloadBytes);
      right("");
    } catch (e) {
      left(GenericFailure(message: 'Error sending request: $e', error: e));
      _isConnected = false;
    }
  }

  void closeSocket() {
    try {
      _socket?.close();
    } catch (e) {
      print('Error closing socket: $e');
      _isConnected = false;
    }
  }
}
