import 'package:shared_preferences/shared_preferences.dart';
import 'package:ztc/src/exceptions/safe_execution.dart';

/// An abstract class for managing authentication tokens in persistent storage.
///
/// The `AuthTokenDataStore` class defines methods for saving, retrieving, and clearing
/// authentication tokens. Implementations of this class should provide the actual logic
/// for interacting with the storage system.
abstract class AuthTokenDataStore {
  static const String keyAuthToken = 'auth_token';
  static const String keyTokenTimestamp = 'token_timestamp';

  /// Saves the authentication token to persistent storage.
  ///
  /// [token] is the authentication token to be saved.
  Future<void> saveAuthToken(String token);

  /// Retrieves the authentication token from persistent storage.
  ///
  /// Returns a `ResultFuture` which is either a `Failure` or a `String` representing the token.
  Future<ResultFuture<String>> getAuthToken();

  /// Clears the authentication token from persistent storage.
  Future<void> clearAuthToken();
}

/// A factory function for creating an instance of `AuthTokenDataStore`.
///
/// [isTimestampExpired] is a function that determines if the token's timestamp is expired.
/// [tokenValidityDuration] is the duration (in seconds) for which the token is valid.
AuthTokenDataStore buildAuthTokenDataStore({
  required bool Function(int, int) isTimestampExpired,
  required int tokenValidityDuration,
}) {
  return _AuthTokenDataStore(
    isTimestampExpired: isTimestampExpired,
    tokenValidityDuration: tokenValidityDuration,
  );
}

/// An implementation of `AuthTokenDataStore` that uses `SharedPreferences` for persistent storage.
class _AuthTokenDataStore implements AuthTokenDataStore {
  final int _tokenValidityDuration; // in seconds
  final bool Function(int, int) isTimestampExpired;

  _AuthTokenDataStore(
      {required this.isTimestampExpired, required int tokenValidityDuration})
      : _tokenValidityDuration = tokenValidityDuration;

  /// Saves the authentication token to `SharedPreferences`.
  ///
  /// [token] is the authentication token to be saved.
  @override
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthTokenDataStore.keyAuthToken, token);
    await prefs.setInt(AuthTokenDataStore.keyTokenTimestamp,
        DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  /// Retrieves the authentication token from `SharedPreferences`.
  ///
  /// If the token is expired or not found, an exception is thrown.
  /// Returns a `ResultFuture` which is either a `Failure` or a `String` representing the token.
  @override
  Future<ResultFuture<String>> getAuthToken() async {
    return await safeExecute(() async {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(AuthTokenDataStore.keyTokenTimestamp);
      if (timestamp == null) {
        throw Exception('Token timestamp not found');
      }
      if (isTimestampExpired(timestamp, _tokenValidityDuration)) {
        await clearAuthToken();
        throw Exception('Token expired');
      }
      final token = prefs.getString(AuthTokenDataStore.keyAuthToken);
      if (token == null) {
        throw Exception('Auth token not found');
      }
      return token;
    });
  }

  /// Clears the authentication token from `SharedPreferences`.
  @override
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthTokenDataStore.keyAuthToken);
    await prefs.remove(AuthTokenDataStore.keyTokenTimestamp);
  }
}
