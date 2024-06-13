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
import 'package:ztc/src/data/bytes_converter.dart';
import 'package:ztc/src/data/bytes_converter_provider.dart';
import 'package:ztc/src/data/log_data_store.dart';
import 'package:ztc/src/data/log_data_store_provider.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/data/socket_data_store_provider.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockAuthTokenDataStore extends Mock implements AuthTokenDataStore {}

class MockBytesManager extends Mock implements BytesConverter {}

class MockLogManager extends Mock implements LogDataStore {}

class MockSocketRepository extends Mock implements SocketDataStore {}

class MockTimerManager extends Mock implements TimerManager {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Create instances of the mock classes
  final mockAuthService = MockAuthService();
  final mockAuthTokenDataStore = MockAuthTokenDataStore();
  final mockBytesManager = MockBytesManager();
  final mockLogManager = MockLogManager();
  final mockSocketRepository = MockSocketRepository();
  final mockTimerManager = MockTimerManager();

  testWidgets('ZTCHomePage UI Test with mocked dependencies',
      (WidgetTester tester) async {
    when(() => mockLogManager.log).thenReturn([]);
    when(() => mockAuthTokenDataStore.getAuthToken())
        .thenAnswer((_) async => const Right("1234"));
    when(() => mockAuthTokenDataStore.clearAuthToken())
        .thenAnswer((_) async => Void);
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
          bytesConverterProvider.overrideWithValue(mockBytesManager),
          logDataStoreProvider.overrideWithValue(mockLogManager),
          socketDataStoreProvider.overrideWithValue(mockSocketRepository),
          timerManagerProvider.overrideWithValue(mockTimerManager),
          connectionServiceNotifierProvider.overrideWith((ref) {
            return ConnectionServiceNotifier(
              ref.read(bytesConverterProvider),
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
