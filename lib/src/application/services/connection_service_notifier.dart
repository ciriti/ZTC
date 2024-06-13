import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/application/services/auth_service_provider.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/data/auth_token_data_store_provider.dart';
import 'package:ztc/src/data/bytes_manager.dart';
import 'package:ztc/src/data/bytes_manager_provider.dart';
import 'package:ztc/src/data/log_manager.dart';
import 'package:ztc/src/domain/models/socket_state.dart';
import 'package:ztc/src/utils/ext.dart';
import 'package:ztc/src/data/log_manager_provider.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';

class ConnectionServiceNotifier extends StateNotifier<SocketState> {
  final BytesManager bytesManager;
  final AuthService authService;
  final LogManager logManager;
  final AuthTokenDataStore authTokenDataStore;

  ConnectionServiceNotifier(this.bytesManager, this.authService,
      this.logManager, this.authTokenDataStore)
      : super(const SocketDisconnected());

  Future<void> connect() async {
    logManager.addLog('Daemon: Attempting to connect...');
    state = const SocketConnecting();

    final ResultFuture<String> cachedTokenResult =
        await authTokenDataStore.getAuthToken();

    cachedTokenResult.fold(
      (failure) async {
        // No valid cached token, fetch a new one
        final tokenResult = await authService.getAuthToken();

        tokenResult.fold(
          (failure) {
            state = const SocketError('Failed to fetch the Auth token');
            logManager.addLog('Failed to fetch the Auth token');
          },
          (authToken) async {
            await _handleAuthToken(authToken);
          },
        );
      },
      (cachedToken) async {
        // Valid cached token exists, use it
        await _handleAuthToken(cachedToken);
      },
    );
  }

  Future<void> _handleAuthToken(String authToken) async {
    try {
      final result = await _sendRequest({
        "request": {
          "connect": int.parse(authToken),
        }
      });

      if (result['data']['daemon_status'] == 'connected') {
        state = const SocketConnected();
        logManager.addLog(const SocketConnected().toString());
        // after a successful connection from the daemon,
        //the app MUST discard the cached registration token
        await authTokenDataStore.clearAuthToken();
      } else {
        state = const SocketError('Failed to connect');
        logManager.addLog('Failed to connect');
        // if the daemon returns an error following the connect request,
        // the app MUST cache the authentication token
        await authTokenDataStore.saveAuthToken(authToken);
      }
    } catch (e) {
      state = const SocketError("Error");
      logManager.addLog("Error ${e.toString()}");
    }
  }

  Future<void> disconnect() async {
    logManager.addLog('Daemon: Attempting to disconnect...');
    state = const SocketDisconnecting();

    try {
      final result = await _sendRequest({
        "request": "disconnect",
      });

      if (result['data']['daemon_status'] == 'disconnected') {
        state = const SocketDisconnected();
        logManager.addLog(const SocketDisconnected().toString());
      } else {
        state = const SocketError('Failed to disconnect');
        logManager.addLog('Failed to disconnect');
      }
    } catch (e) {
      state = const SocketError("Error");
      logManager.addLog("Error ${e.toString()}");
    }
  }

  Future<void> getStatus() async {
    logManager.addLog('Status: Attempting to refresh...');
    try {
      final result = await _sendRequest({
        "request": "get_status",
      });

      print(result);
      logManager.addLog('Status: [$result]');

      if (result['data']['daemon_status'] == 'connected') {
        state = const SocketConnected();
        logManager.addLog('Status: Connected [$result]');
      } else if (result['data']['daemon_status'] == 'disconnected') {
        state = const SocketDisconnected();
        logManager.addLog('Status: Disconnected [$result]');
      } else {
        state = const SocketError('Failed to disconnect');
        logManager.addLog('Status: Failed to disconnect [$result]');
      }
    } catch (e) {
      state = SocketError(e.toString());
      logManager.addLog("Status: Error ${e.toString()}");
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

final connectionServiceNotifierProvider =
    StateNotifierProvider<ConnectionServiceNotifier, SocketState>((ref) {
  final bytesManager = ref.read(bytesManagerProvider);
  final AuthService client = ref.read(authServiceProvider);
  final logManager = ref.read(logManagerProvider);
  final AuthTokenDataStore authTokenDS = ref.read(authTokenProvider);
  return ConnectionServiceNotifier(
      bytesManager, client, logManager, authTokenDS);
});
