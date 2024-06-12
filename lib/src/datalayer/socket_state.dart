sealed class SocketState {
  const SocketState();
}

final class SocketInitial extends SocketState {
  const SocketInitial();

  @override
  String toString() => 'SocketInitial()';
}

final class SocketConnecting extends SocketState {
  const SocketConnecting();

  @override
  String toString() => 'SocketConnecting()';
}

final class SocketConnected extends SocketState {
  const SocketConnected();

  @override
  String toString() => 'SocketConnected()';
}

final class SocketDisconnecting extends SocketState {
  const SocketDisconnecting();

  @override
  String toString() => 'SocketDisconnecting()';
}

final class SocketDisconnected extends SocketState {
  const SocketDisconnected();

  @override
  String toString() => 'SocketDisconnected()';
}

final class SocketError extends SocketState {
  final String message;
  const SocketError(this.message);

  @override
  String toString() => 'SocketError(message: $message)';
}

final class SocketDataReceived extends SocketState {
  final String message;
  const SocketDataReceived(this.message);

  @override
  String toString() => message;
}
