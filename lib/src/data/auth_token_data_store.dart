import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthTokenDataStore {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
}

AuthTokenDataStore buildAuthTokenDataStore() {
  return _AuthTokenDataStore(
    isTimestampExpired: _isTimestampExpired,
    tokenValidityDuration: 5,
  );
}

class _AuthTokenDataStore implements AuthTokenDataStore {
  static const String _keyAuthToken = 'auth_token';
  static const String _keyTokenTimestamp = 'token_timestamp';
  final int _tokenValidityDuration; // in seconds
  final bool Function(int, int) isTimestampExpired;

  _AuthTokenDataStore(
      {required this.isTimestampExpired, required int tokenValidityDuration})
      : _tokenValidityDuration = tokenValidityDuration;

  @override
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
    await prefs.setInt(
        _keyTokenTimestamp, DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  @override
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_keyTokenTimestamp);
    if (timestamp == null) {
      return null;
    }
    if (isTimestampExpired(timestamp, _tokenValidityDuration)) {
      await clearAuthToken();
      return null;
    }
    return prefs.getString(_keyAuthToken);
  }

  @override
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyTokenTimestamp);
  }
}

bool _isTimestampExpired(int timestamp, int validitySeconds) {
  final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return (currentTime - timestamp) > validitySeconds;
}
