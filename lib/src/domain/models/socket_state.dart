/// Represents the different states of the socket connection.
sealed class SocketState {
  const SocketState();
}

/// The initial state of the socket connection.
final class SocketInitial extends SocketState {
  const SocketInitial();

  @override
  String toString() => 'Init';
}

/// The state when the socket is attempting to connect.
final class SocketConnecting extends SocketState {
  const SocketConnecting();

  @override
  String toString() => 'Connecting';
}

/// The state when the socket is successfully connected.
final class SocketConnected extends SocketState {
  const SocketConnected();

  @override
  String toString() => 'Connected';
}

/// The state when the socket is attempting to disconnect.
final class SocketDisconnecting extends SocketState {
  const SocketDisconnecting();

  @override
  String toString() => 'Disconnecting';
}

/// The state when the socket is successfully disconnected.
final class SocketDisconnected extends SocketState {
  const SocketDisconnected();

  @override
  String toString() => 'Disconnected';
}

/// The state when an error occurs with the socket connection.
final class SocketError extends SocketState {
  final String message;
  SocketError(this.message);

  @override
  String toString() => 'Error(message: $message)';
}

/// The state when data is received from the socket.
final class SocketDataReceived extends SocketState {
  final String message;
  const SocketDataReceived(this.message);

  @override
  String toString() => message;
}
