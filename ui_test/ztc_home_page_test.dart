import 'dart:convert';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ztc/main.dart'; // Ensure this is the correct path to your main.dart file
import 'package:ztc/src/application/services/auth_service.dart';
import 'package:ztc/src/application/services/auth_service_provider.dart';
import 'package:ztc/src/application/services/connection_service_notifier.dart';
import 'package:ztc/src/application/services/timer_manager.dart';
import 'package:ztc/src/application/services/timer_manager_provider.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';
import 'package:ztc/src/data/auth_token_data_store_provider.dart';
import 'package:ztc/src/data/log_data_store.dart';
import 'package:ztc/src/data/log_data_store_provider.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/data/socket_data_store_provider.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockAuthTokenDataStore extends Mock implements AuthTokenDataStore {}

class MockLogManager extends Mock implements LogDataStore {}

class MockSocketRepository extends Mock implements SocketDataStore {}

class MockTimerManager extends Mock implements TimerManager {}

class MockSocketDataStore extends Mock implements SocketDataStore {
  late Function(String) success;
  late Function(String) failure;
  final String json;

  // Empty constructor with default json value
  MockSocketDataStore()
      : json = '{"status":"success","data":{"daemon_status":"connected"}}';

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Create instances of the mock classes
  final mockAuthService = MockAuthService();
  final mockAuthTokenDataStore = MockAuthTokenDataStore();
  final mockLogManager = MockLogManager();
  final mockSocketRepository = MockSocketRepository();
  final mockTimerManager = MockTimerManager();
  final mockSocketDataStore = MockSocketDataStore();

  testWidgets('ZTCHomePage UI Test with mocked dependencies',
      (WidgetTester tester) async {
    when(() => mockLogManager.log).thenReturn([]);
    when(() => mockAuthTokenDataStore.getAuthToken())
        .thenAnswer((_) async => const Right("1234"));
    when(() => mockAuthTokenDataStore.clearAuthToken())
        .thenAnswer((_) async => Void);
    when(() => mockAuthTokenDataStore.saveAuthToken(any()))
        .thenAnswer((_) async {});
    when(() => mockAuthService.getAuthToken())
        .thenAnswer((_) async => const Right("1234"));
    when(() => mockSocketRepository.sendRequest(any())).thenAnswer((_) async =>
        jsonDecode(
            '{"status":"success","data":{"daemon_status":"connected"}}'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          authTokenProvider.overrideWithValue(mockAuthTokenDataStore),
          logDataStoreProvider.overrideWithValue(mockLogManager),
          socketDataStoreProvider.overrideWithValue(mockSocketRepository),
          timerManagerProvider.overrideWithValue(mockTimerManager),
          socketDataStoreProvider.overrideWithValue(mockSocketDataStore),
          connectionServiceNotifierProvider.overrideWith((ref) {
            return ConnectionServiceNotifier(
              ref.read(authServiceProvider),
              ref.read(logDataStoreProvider),
              ref.read(authTokenProvider),
              ref.read(socketDataStoreProvider),
            );
          }),
        ],
        child: const ZTCApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Verify initial status
    expect(find.text('Status: Disconnected'), findsOneWidget);

    // Tap the 'Connect' button
    await tester.tap(find.text('Connect'));
    await tester.pumpAndSettle();

    // Verify the status
    expect(find.text('Status: Connected'), findsOneWidget);
  });
}
