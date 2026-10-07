import 'dart:async';

enum NovaNetworkState {
  unavailable,
  available,
}

class NetworkMonitor {
  NovaNetworkState _state = NovaNetworkState.unavailable;

  final StreamController<NovaNetworkState> _stateController =
      StreamController<NovaNetworkState>.broadcast();

  NovaNetworkState get state => _state;

  Stream<NovaNetworkState> get stateStream => _stateController.stream;

  void updateState(NovaNetworkState state) {
    _state = state;
    _stateController.add(state);
  }

  void dispose() {
    _stateController.close();
  }
}
