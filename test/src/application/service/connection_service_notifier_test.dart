import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/application/services/connection_service_notifier.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/data/bytes_converter.dart';
import 'package:ztc/src/data/log_data_store.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/domain/models/socket_state.dart';

// Mock classes
class MockBytesManager extends Mock implements BytesConverter {}

class MockAuthService extends Mock implements AuthService {}

class MockLogManager extends Mock implements LogDataStore {}

class MockAuthTokenDataStore extends Mock implements AuthTokenDataStore {}

class MockSocketRepository extends Mock implements SocketDataStore {}

void main() {
  late MockBytesManager mockBytesManager;
  late MockAuthService mockAuthService;
  late MockLogManager mockLogManager;
  late MockAuthTokenDataStore mockAuthTokenDataStore;
  late MockSocketRepository mockSocketRepository;
  late ConnectionServiceNotifier connectionServiceNotifier;

  setUp(() {
    mockBytesManager = MockBytesManager();
    mockAuthService = MockAuthService();
    mockLogManager = MockLogManager();
    mockAuthTokenDataStore = MockAuthTokenDataStore();
    mockSocketRepository = MockSocketRepository();
    connectionServiceNotifier = ConnectionServiceNotifier(
      mockBytesManager,
      mockAuthService,
      mockLogManager,
      mockAuthTokenDataStore,
      mockSocketRepository,
    );
  });

  test("connect should update state to SocketConnected on success", () async {
    // Arrange
    when(() => mockAuthTokenDataStore.getAuthToken())
        .thenAnswer((_) async => const Right("1234"));
    when(() => mockSocketRepository.sendRequest(any())).thenAnswer((_) async =>
        jsonDecode(
            '{"status":"success","data":{"daemon_status":"connected"}}'));
    when(() => mockAuthTokenDataStore.clearAuthToken())
        .thenAnswer((_) async {});

    // Act
    await connectionServiceNotifier.connect();

    // Assert
    await expectLater(
        connectionServiceNotifier.stream,
        emitsInOrder([
          isA<SocketConnected>(),
        ]));
  });

  test('disconnect should update state to SocketDisconnected on success',
      () async {
    // Arrange
    when(() => mockSocketRepository.sendRequest(any()))
        .thenAnswer((_) async => {
              'data': {'daemon_status': 'disconnected'}
            });

    // Act
    await connectionServiceNotifier.disconnect();

    // Assert
    expect(connectionServiceNotifier.state, isA<SocketDisconnected>());
  });

  test('getStatus should update state based on daemon status', () async {
    // Arrange
    when(() => mockSocketRepository.sendRequest(any()))
        .thenAnswer((_) async => {
              'data': {'daemon_status': 'connected'}
            });

    // Act
    await connectionServiceNotifier.getStatus();

    // Assert
    expect(connectionServiceNotifier.state, isA<SocketConnected>());

    // Arrange for disconnected status
    when(() => mockSocketRepository.sendRequest(any()))
        .thenAnswer((_) async => {
              'data': {'daemon_status': 'disconnected'}
            });

    // Act
    await connectionServiceNotifier.getStatus();

    // Assert
    expect(connectionServiceNotifier.state, isA<SocketDisconnected>());
  });
}
