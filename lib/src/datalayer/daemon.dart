import 'dart:async';
import 'dart:convert';

import 'package:ztc/src/datalayer/socket_state.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DaemonConnection {
  final StreamController<SocketState> _stateController =
      StreamController<SocketState>.broadcast();

  Stream<SocketState> get state => _stateController.stream;

  Future<void> connect({required int authToken}) async {
    _stateController.add(const SocketConnecting());

    final result = await safeExecute(() => _sendRequest({
          "request": {
            "connect": authToken,
          }
        }));

    result.fold(
      (failure) {
        _stateController.add(SocketError(failure.message));
        print(failure.message);
      },
      (response) {
        if (response['data']['daemon_status'] == 'connected') {
          _stateController.add(const SocketConnected());
        } else {
          _stateController.add(const SocketError('Failed to connect'));
        }
      },
    );
  }

  Future<void> disconnect() async {
    _stateController.add(const SocketDisconnecting());

    final result = await safeExecute(() => _sendRequest({
          "request": "disconnect",
        }));

    result.fold(
      (failure) => _stateController.add(SocketError(failure.message)),
      (response) {
        if (response['data']['daemon_status'] == 'disconnected') {
          _stateController.add(const SocketDisconnected());
        } else {
          _stateController.add(const SocketError('Failed to disconnect'));
        }
      },
    );
  }

  Future<Map<String, dynamic>> _sendRequest(
      Map<String, dynamic> requestPayload) async {
    final socket = await _connectToSocket();

    try {
      // Serialize the payload into a JSON string
      String jsonPayload = jsonEncode(requestPayload);
      List<int> payloadBytes = utf8.encode(jsonPayload);

      // Send the size of the payload first
      int payloadSize = payloadBytes.length;
      socket.add(payloadSize.toBytes());

      // Send the payload
      socket.add(payloadBytes);

      // Read the response size first
      List<int> responseSizeBytes = await _readBytes(socket, 8);
      int responseSize = _bytesToInt64(responseSizeBytes);
      print('Expected response size: $responseSize');

      // Read the response payload
      List<int> responseBytes = await _readBytes(socket, responseSize);
      print('Actual response size: ${responseBytes.length}');

      String jsonResponse = utf8.decode(responseBytes);

      return jsonDecode(jsonResponse);
    } finally {
      socket.close();
    }
  }

  List<int> _int64ToBytes(int value) {
    var bytes = <int>[];
    for (int i = 0; i < 8; i++) {
      bytes.add(value & 0xFF);
      value >>= 8;
    }
    return bytes.reversed.toList();
  }

  int _bytesToInt64(List<int> bytes) {
    int value = 0;
    for (int i = 0; i < 8; i++) {
      value <<= 8;
      value |= bytes[i] & 0xFF;
    }
    return value;
  }

  Future<Socket> _connectToSocket() async {
    var tempDir = await getTemporaryDirectory();
    var tempDirPath = tempDir.path;
    String socketPath = "$tempDirPath/daemon-lite";
    final socket = await Socket.connect(
      InternetAddress(socketPath, type: InternetAddressType.unix),
      0,
    );
    return socket;
  }

  Future<List<int>> _readBytes(Socket socket, int numBytes) async {
    final Completer<List<int>> completer = Completer<List<int>>();
    final List<int> buffer = [];
    int bytesRead = 0;

    socket.listen(
      (data) {
        buffer.addAll(data);
        bytesRead += data.length;
        if (buffer.length >= numBytes) {
          completer.complete(buffer.sublist(0, numBytes));
        }
      },
      onError: (error, StackTrace stackTrace) {
        completer.completeError(error, stackTrace);
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.completeError(Exception(
              'Socket closed before receiving enough data. Bytes read: $bytesRead, Expected: $numBytes'));
        }
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  // Future<List<int>> _readBytes(Socket socket, int numBytes) async {
  //   final Completer<List<int>> completer = Completer<List<int>>();
  //   final List<int> buffer = [];

  //   socket.listen(
  //     (data) {
  //       buffer.addAll(data);
  //       if (buffer.length >= numBytes) {
  //         completer.complete(buffer.sublist(0, numBytes));
  //       }
  //     },
  //     onError: (error, StackTrace stackTrace) {
  //       completer.completeError(error, stackTrace);
  //     },
  //     onDone: () {
  //       if (!completer.isCompleted) {
  //         completer.completeError(
  //             Exception('Socket closed before receiving enough data'));
  //       }
  //     },
  //     cancelOnError: true,
  //   );

  //   return completer.future;
  // }

  void dispose() {
    _stateController.close();
  }
}

extension IntBytes on int {
  List<int> toBytes() {
    var bytes = <int>[];
    for (int i = 0; i < 8; i++) {
      bytes.add((this >> (i * 8)) & 0xFF);
    }
    return bytes;
  }
}

extension BytesInt on List<int> {
  int toInt() {
    int value = 0;
    for (int i = 0; i < 8; i++) {
      value |= (this[i] & 0xFF) << (i * 8);
    }
    return value;
  }
}
