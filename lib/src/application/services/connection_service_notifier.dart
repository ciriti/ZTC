import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/application/services/auth_service_provider.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/data/auth_token_data_store_provider.dart';
import 'package:ztc/src/data/bytes_converter.dart';
import 'package:ztc/src/data/bytes_converter_provider.dart';
import 'package:ztc/src/data/log_data_store.dart';
import 'package:ztc/src/data/log_data_store_provider.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/data/socket_data_store_provider.dart';
import 'package:ztc/src/domain/models/socket_state.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';

class ConnectionServiceNotifier extends StateNotifier<SocketState> {
  final BytesConverter bytesConverter;
  final AuthService authService;
  final LogDataStore logManager;
  final AuthTokenDataStore authTokenDataStore;
  final SocketDataStore socketRepository;

  ConnectionServiceNotifier(this.bytesConverter, this.authService,
      this.logManager, this.authTokenDataStore, this.socketRepository)
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
      final result = await socketRepository.sendRequest({
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
      final result = await socketRepository.sendRequest({
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
      final result = await socketRepository.sendRequest({
        "request": "get_status",
      });

      print(result); // TODO remove this line
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
}

final connectionServiceNotifierProvider =
    StateNotifierProvider<ConnectionServiceNotifier, SocketState>((ref) {
  final bytesConverter = ref.read(bytesConverterProvider);
  final AuthService client = ref.read(authServiceProvider);
  final logManager = ref.read(logDataStoreProvider);
  final SocketDataStore socketRepository = ref.read(socketDataStoreProvider);
  final AuthTokenDataStore authTokenDS = ref.read(authTokenProvider);
  return ConnectionServiceNotifier(
    bytesConverter,
    client,
    logManager,
    authTokenDS,
    socketRepository,
  );
});
