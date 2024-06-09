sealed class ZTCException implements Exception {
  final String message;
  ZTCException(this.message);

  @override
  String toString() => 'ZTCException: $message';
}

class RegistrationException extends ZTCException {
  RegistrationException(super.message);
}

class ConnectionException extends ZTCException {
  ConnectionException(super.message);
}

class DisconnectionException extends ZTCException {
  DisconnectionException(super.message);
}

class StatusCheckException extends ZTCException {
  StatusCheckException(super.message);
}

class CacheException extends ZTCException {
  CacheException(super.message);
}
