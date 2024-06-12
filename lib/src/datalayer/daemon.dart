import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/datalayer/bytes_manager.dart';
import 'package:ztc/src/datalayer/socket_state.dart';

class DaemonConnectionNotifier extends StateNotifier<List<SocketState>> {
  final Bytesmanager bytesManager;

  DaemonConnectionNotifier(this.bytesManager) : super([const SocketInitial()]);

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

      // Read the response size
      final jsonResponse = await _readBytes(socket);
      print('Received response: $jsonResponse');

      return jsonResponse;
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

  Future<Map<String, dynamic>> _readBytes(Socket socket) async {
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

        print(json);

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
  final bytesManager = ref.read(bytesManagerProvider);
  return DaemonConnectionNotifier(bytesManager);
});
