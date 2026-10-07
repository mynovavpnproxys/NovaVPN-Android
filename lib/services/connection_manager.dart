import 'dart:async';

import 'android_vpn_bridge.dart';

enum NovaConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
  reconnecting,
  error,
}

class ConnectionManager {
  final AndroidVpnBridge _bridge;

  NovaConnectionState _state = NovaConnectionState.disconnected;

  final StreamController<NovaConnectionState> _stateController =
      StreamController<NovaConnectionState>.broadcast();

  ConnectionManager({
    AndroidVpnBridge? bridge,
  }) : _bridge = bridge ?? AndroidVpnBridge();

  NovaConnectionState get state => _state;

  Stream<NovaConnectionState> get stateStream => _stateController.stream;

  Future<void> connect() async {
    if (_state == NovaConnectionState.connected ||
        _state == NovaConnectionState.connecting) {
      return;
    }

    _setState(NovaConnectionState.connecting);

    try {
      final connected = await _bridge.connect();

      if (connected) {
        _setState(NovaConnectionState.connected);
      } else {
        _setState(NovaConnectionState.error);
        _setState(NovaConnectionState.disconnected);
      }
    } catch (_) {
      _setState(NovaConnectionState.error);
      _setState(NovaConnectionState.disconnected);
    }
  }

  Future<void> disconnect() async {
    if (_state == NovaConnectionState.disconnected ||
        _state == NovaConnectionState.disconnecting) {
      return;
    }

    _setState(NovaConnectionState.disconnecting);

    try {
      await _bridge.disconnect();
    } finally {
      _setState(NovaConnectionState.disconnected);
    }
  }

  void _setState(NovaConnectionState state) {
    _state = state;
    _stateController.add(state);
  }

  void dispose() {
    _stateController.close();
  }
}
