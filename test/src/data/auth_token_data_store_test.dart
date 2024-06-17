import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ztc/src/data/auth_token_data_store.dart';

void main() {
  late SharedPreferences preferences;
  late AuthTokenDataStore dataStore;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({}); //set values here
    preferences = await SharedPreferences.getInstance();
    dataStore = buildAuthTokenDataStore(
      isTimestampExpired: _isTimestampExpired,
      tokenValidityDuration: 1,
    );
  });

  test('saveAuthToken saves token and timestamp', () async {
    // Act
    await dataStore.saveAuthToken('test_token');

    // Assert
    expect(
        preferences.getString(AuthTokenDataStore.keyAuthToken), 'test_token');
    expect(preferences.getInt(AuthTokenDataStore.keyTokenTimestamp), isNotNull);
  });

  test('getAuthToken returns token if not expired', () async {
    // Act
    await dataStore.saveAuthToken('test_token');

    final token = await dataStore.getAuthToken();
    // Assert
    expect(token, isA<Right>());
  });

  test('getAuthToken returns null if expired', () async {
    // Act
    await dataStore.saveAuthToken('test_token');
    await Future.delayed(
        const Duration(seconds: 2)); // Wait for token to expire

    final token = await dataStore.getAuthToken();

    // Assert
    expect(token, isA<Left>());
  });

  test('clearAuthToken clears token and timestamp', () async {
    // Act
    await dataStore.saveAuthToken('test_token');
    await dataStore.clearAuthToken();
    // Assert
    expect(preferences.getString(AuthTokenDataStore.keyAuthToken), isNull);
    expect(preferences.getInt(AuthTokenDataStore.keyTokenTimestamp), isNull);
  });
}

bool _isTimestampExpired(int timestamp, int validitySeconds) {
  final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return (currentTime - timestamp) > validitySeconds;
}
