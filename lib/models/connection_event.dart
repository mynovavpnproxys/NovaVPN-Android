enum ConnectionEventType {
  connecting,
  connected,
  disconnecting,
  disconnected,
  reconnecting,
  networkChanged,
  error,
}

class ConnectionEvent {
  final ConnectionEventType type;
  final DateTime timestamp;
  final String? message;

  const ConnectionEvent({
    required this.type,
    required this.timestamp,
    this.message,
  });
}
