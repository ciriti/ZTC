import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/data/bytes_manager.dart';
import 'package:ztc/src/data/socket_state.dart';
import 'package:ztc/src/data/auth_service.dart';
import 'package:ztc/src/utils/ext.dart';

class DaemonConnectionNotifier extends StateNotifier<SocketState> {
  final BytesManager bytesManager;
  final AuthService authService;

  DaemonConnectionNotifier(this.bytesManager, this.authService)
      : super(const SocketDisconnected());

  Future<void> connect() async {
    state = const SocketConnecting();

    var tokenResult = await authService.getAuthToken();

    tokenResult.fold(
      (failure) {
        state = const SocketError('Failed to fetch the Auth token');
      },
      (authToken) async {
        try {
          final result = await _sendRequest({
            "request": {
              "connect": int.parse(authToken),
            }
          });

          if (result['data']['daemon_status'] == 'connected') {
            state = const SocketConnected();
          } else {
            state = const SocketError('Failed to connect');
          }
        } catch (e) {
          state = SocketError(e.toString());
        }
      },
    );
  }

  Future<void> disconnect() async {
    state = const SocketDisconnecting();

    try {
      final result = await _sendRequest({
        "request": "disconnect",
      });

      if (result['data']['daemon_status'] == 'disconnected') {
        state = const SocketDisconnected();
      } else {
        state = const SocketError('Failed to disconnect');
      }
    } catch (e) {
      state = SocketError(e.toString());
    }
  }

  Future<void> getStatus() async {
    try {
      final result = await _sendRequest({
        "request": "get_status",
      });

      print(result);

      if (result['data']['daemon_status'] == 'connected') {
        state = const SocketConnected();
      } else if (result['data']['daemon_status'] == 'disconnected') {
        state = const SocketDisconnected();
      } else {
        state = const SocketError('Failed to disconnect');
      }
    } catch (e) {
      state = SocketError(e.toString());
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
      final jsonResponse = await bytesManager.readBytes(socket);
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
}

final daemonConnectionProvider =
    StateNotifierProvider<DaemonConnectionNotifier, SocketState>((ref) {
  final bytesManager = ref.read(bytesManagerProvider);
  final AuthService client = ref.read(authServiceProvider);
  return DaemonConnectionNotifier(bytesManager, client);
});
