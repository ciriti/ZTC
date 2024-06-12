import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthTokenDataStore {
  static const String keyAuthToken = 'auth_token';
  static const String keyTokenTimestamp = 'token_timestamp';
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
}

AuthTokenDataStore buildAuthTokenDataStore({
  required bool Function(int, int) isTimestampExpired,
  required int tokenValidityDuration,
}) {
  return _AuthTokenDataStore(
    isTimestampExpired: isTimestampExpired,
    tokenValidityDuration: tokenValidityDuration,
  );
}

class _AuthTokenDataStore implements AuthTokenDataStore {
  final int _tokenValidityDuration; // in seconds
  final bool Function(int, int) isTimestampExpired;

  _AuthTokenDataStore(
      {required this.isTimestampExpired, required int tokenValidityDuration})
      : _tokenValidityDuration = tokenValidityDuration;

  @override
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthTokenDataStore.keyAuthToken, token);
    await prefs.setInt(AuthTokenDataStore.keyTokenTimestamp,
        DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(AuthTokenDataStore.keyTokenTimestamp);
    if (timestamp == null) {
      return null;
    }
    if (isTimestampExpired(timestamp, _tokenValidityDuration)) {
      await clearAuthToken();
      return null;
    }
    return prefs.getString(AuthTokenDataStore.keyAuthToken);
  }

  @override
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthTokenDataStore.keyAuthToken);
    await prefs.remove(AuthTokenDataStore.keyTokenTimestamp);
  }
}
