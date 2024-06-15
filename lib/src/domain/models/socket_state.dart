sealed class SocketState {
  const SocketState();
}

final class SocketInitial extends SocketState {
  const SocketInitial();

  @override
  String toString() => 'Init';
}

final class SocketConnecting extends SocketState {
  const SocketConnecting();

  @override
  String toString() => 'Connecting';
}

final class SocketConnected extends SocketState {
  const SocketConnected();

  @override
  String toString() => 'Connected';
}

final class SocketDisconnecting extends SocketState {
  const SocketDisconnecting();

  @override
  String toString() => 'Disconnecting';
}

final class SocketDisconnected extends SocketState {
  const SocketDisconnected();

  @override
  String toString() => 'Disconnected';
}

final class SocketError extends SocketState {
  final String message;
  SocketError(this.message);

  @override
  String toString() => 'Error(message: $message)';
}

final class SocketDataReceived extends SocketState {
  final String message;
  const SocketDataReceived(this.message);

  @override
  String toString() => message;
}
