import 'dart:async';

import '../models/connection_event.dart';

class ConnectionEventService {
  final StreamController<ConnectionEvent> _eventController =
      StreamController<ConnectionEvent>.broadcast();

  Stream<ConnectionEvent> get events => _eventController.stream;

  void emit(
    ConnectionEventType type, {
    String? message,
  }) {
    _eventController.add(
      ConnectionEvent(
        type: type,
        timestamp: DateTime.now(),
        message: message,
      ),
    );
  }

  void dispose() {
    _eventController.close();
  }
}
