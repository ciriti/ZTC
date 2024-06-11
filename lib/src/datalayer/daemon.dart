import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/datalayer/socket_state.dart';

class DaemonConnectionNotifier extends StateNotifier<List<SocketState>> {
  DaemonConnectionNotifier() : super([const SocketInitial()]);

  Future<void> connect(int authToken) async {
    state = [...state, const SocketConnecting()];

    try {
      final result = await _sendRequest({
        "request": {
          "connect": authToken,
        }
      });

      if (result['data']['daemon_status'] == 'connected') {
        state = [...state, const SocketConnected()];
      } else {
        state = [...state, const SocketError('Failed to connect')];
      }
    } catch (e) {
      state = [...state, SocketError(e.toString())];
    }
  }

  Future<void> disconnect() async {
    state = [...state, const SocketDisconnecting()];

    try {
      final result = await _sendRequest({
        "request": "disconnect",
      });

      if (result['data']['daemon_status'] == 'disconnected') {
        state = [...state, const SocketDisconnected()];
      } else {
        state = [...state, const SocketError('Failed to disconnect')];
      }
    } catch (e) {
      state = [...state, SocketError(e.toString())];
    }
  }

  Future<Map<String, dynamic>> _sendRequest(
      Map<String, dynamic> requestPayload) async {
    final socket = await _connectToSocket();

    try {
      String jsonPayload = jsonEncode(requestPayload);
      List<int> payloadBytes = utf8.encode(jsonPayload);
      int payloadSize = payloadBytes.length;
      socket.add(payloadSize.toBytes());
      socket.add(payloadBytes);

      List<int> responseSizeBytes = await _readBytes(socket, 8);
      int responseSize = responseSizeBytes.toInt();
      List<int> responseBytes = await _readBytes(socket, responseSize);
      String jsonResponse = utf8.decode(responseBytes);

      return jsonDecode(jsonResponse);
    } finally {
      socket.close();
    }
  }

  Future<Socket> _connectToSocket() async {
    var tempDir = await getTemporaryDirectory();
    String socketPath = "${tempDir.path}/daemon-lite";
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

final daemonConnectionProvider =
    StateNotifierProvider<DaemonConnectionNotifier, List<SocketState>>((ref) {
  return DaemonConnectionNotifier();
});
