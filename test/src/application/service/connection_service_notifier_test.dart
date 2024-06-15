import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/application/services/connection_service_notifier.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/data/log_data_store.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/domain/models/socket_state.dart';

// Mock classes

class MockAuthService extends Mock implements AuthService {}

class MockLogManager extends Mock implements LogDataStore {}

class MockAuthTokenDataStore extends Mock implements AuthTokenDataStore {}

class MockSocketDataStore extends Mock implements SocketDataStore {
  late Function(String) success;
  late Function(String) failure;
  final String json;

  // Empty constructor with default json value
  MockSocketDataStore() : json = '';

  // Named factory constructor
  factory MockSocketDataStore.withJson(String json) {
    return MockSocketDataStore._internal(json: json);
  }

  MockSocketDataStore._internal({required this.json});

  @override
  Future<void> connectSocket(
      Function(String) success, Function(String) failure) async {
    this.success = success;
    this.failure = failure;
  }

  @override
  Future<void> sendRequest(Map<String, dynamic> requestPayload) async {
    success(json);
    return Future.value();
  }
}

void main() {
  late MockAuthService mockAuthService;
  late MockLogManager mockLogManager;
  late MockAuthTokenDataStore mockAuthTokenDataStore;
  late MockSocketDataStore mockSocketDataStore;
  late ConnectionServiceNotifier connectionServiceNotifier;

  setUp(() {
    mockAuthService = MockAuthService();
    mockLogManager = MockLogManager();
    mockAuthTokenDataStore = MockAuthTokenDataStore();
  });

  test("connect should update state to SocketConnected on success", () async {
    // Arrange
    mockSocketDataStore = MockSocketDataStore.withJson(
        '{"status":"success","data":{"daemon_status":"connected"}}');
    connectionServiceNotifier = ConnectionServiceNotifier(
      mockAuthService,
      mockLogManager,
      mockAuthTokenDataStore,
      mockSocketDataStore,
    );
    when(() => mockAuthTokenDataStore.getAuthToken())
        .thenAnswer((_) async => const Right("1234"));
    when(() => mockAuthTokenDataStore.saveAuthToken(any()))
        .thenAnswer((_) async {});
    when(() => mockAuthTokenDataStore.clearAuthToken())
        .thenAnswer((_) async {});

    // Act
    await connectionServiceNotifier.connectSocket();
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
    mockSocketDataStore = MockSocketDataStore.withJson(
        '{"status":"success","data":{"daemon_status":"disconnected"}}');
    connectionServiceNotifier = ConnectionServiceNotifier(
      mockAuthService,
      mockLogManager,
      mockAuthTokenDataStore,
      mockSocketDataStore,
    );

    // Act
    await connectionServiceNotifier.connectSocket();
    await connectionServiceNotifier.disconnect();

    // Assert
    expect(connectionServiceNotifier.state, isA<SocketDisconnected>());
  });

  test('getStatus should update state based on daemon status', () async {
    // Arrange
    mockSocketDataStore = MockSocketDataStore.withJson(
        '{"status":"success","data":{"daemon_status":"connected"}}');
    connectionServiceNotifier = ConnectionServiceNotifier(
      mockAuthService,
      mockLogManager,
      mockAuthTokenDataStore,
      mockSocketDataStore,
    );
    when(() => mockAuthTokenDataStore.clearAuthToken())
        .thenAnswer((_) async {});

    // Act
    await connectionServiceNotifier.connectSocket();
    await connectionServiceNotifier.getStatus();

    // Assert
    expect(connectionServiceNotifier.state, isA<SocketConnected>());
  });
}
