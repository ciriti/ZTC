import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/application/services/auth_service_provider.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/data/auth_token_data_store_provider.dart';
import 'package:ztc/src/data/log_data_store.dart';
import 'package:ztc/src/data/log_data_store_provider.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/data/socket_data_store_provider.dart';
import 'package:ztc/src/domain/models/socket_response.dart';
import 'package:ztc/src/domain/models/socket_state.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';

class ConnectionServiceNotifier extends StateNotifier<SocketState> {
  final AuthService authService;
  final LogDataStore logManager;
  final AuthTokenDataStore authTokenDataStore;
  final SocketDataStore socketDataStore;

  ConnectionServiceNotifier(this.authService, this.logManager,
      this.authTokenDataStore, this.socketDataStore)
      : super(const SocketDisconnected());

  Future<void> connectSocket() async {
    await socketDataStore.connectSocket(
      _handleAuthToken,
      (error) {
        state = SocketError('Error occurred during data transmission');
        logManager.addLog('Error occurred during data transmission');
      },
    );
  }

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
            state = SocketError('Failed to fetch the Auth token');
            logManager.addLog('Failed to fetch the Auth token');
          },
          (authToken) async {
            // await _handleAuthToken(authToken);
            await authTokenDataStore.saveAuthToken(authToken);
            await socketDataStore.sendRequest({
              "request": {
                "connect": int.parse(authToken),
              }
            });
          },
        );
      },
      (cachedToken) async {
        // Valid cached token exists, use it
        // await _handleAuthToken(cachedToken);
        await authTokenDataStore.saveAuthToken(cachedToken);
        await socketDataStore.sendRequest({
          "request": {
            "connect": int.parse(cachedToken),
          }
        });
      },
    );
  }

  Future<void> _handleAuthToken(String jsonString) async {
    try {
      final result = SocketResponse.fromJson(jsonDecode(jsonString));

      if (result.status == 'success' && result.data != null) {
        switch (result.data!.daemonStatus) {
          case 'connected':
            state = const SocketConnected();
            logManager.addLog(const SocketConnected().toString());
            // after a successful connection from the daemon,
            // the app MUST discard the cached registration token
            await authTokenDataStore.clearAuthToken();
            break;
          case 'disconnected':
            state = const SocketDisconnected();
            final mess = result.data?.message;
            logManager.addLog(
                '${const SocketDisconnected().toString()}${mess != null ? "; $mess" : ""}');

            break;
          default:
            state = SocketError('Unknown daemon status');
            logManager
                .addLog('Unknown daemon status: ${result.data!.daemonStatus}');
            break;
        }
      } else if (result.status == 'error') {
        state = SocketError(result.message ?? 'Unknown error');
        logManager.addLog('Error: ${result.message ?? 'Unknown error'}');
      } else {
        state = SocketError('Failed to connect');
        logManager.addLog('Failed to connect');
      }
    } catch (e) {
      state = SocketError("Error");
      logManager.addLog("Error ${e.toString()}");
    }
  }

  Future<void> disconnect() async {
    logManager.addLog('Daemon: Attempting to disconnect...');
    state = const SocketDisconnecting();

    try {
      await socketDataStore.sendRequest({"request": "disconnect"});
    } catch (e) {
      state = SocketError("Error");
      logManager.addLog("Error ${e.toString()}");
    }
  }

  Future<void> getStatus() async {
    logManager.addLog('Status: Attempting to refresh...');

    try {
      await socketDataStore.sendRequest({"request": "get_status"});
    } catch (e) {
      state = SocketError(e.toString());
      logManager.addLog("Status: Error ${e.toString()}");
    }
  }
}

final connectionServiceNotifierProvider =
    StateNotifierProvider<ConnectionServiceNotifier, SocketState>((ref) {
  final AuthService client = ref.read(authServiceProvider);
  final logManager = ref.read(logDataStoreProvider);
  final SocketDataStore socketRepository = ref.read(socketDataStoreProvider);
  final AuthTokenDataStore authTokenDS = ref.read(authTokenProvider);
  return ConnectionServiceNotifier(
    client,
    logManager,
    authTokenDS,
    socketRepository,
  );
});
