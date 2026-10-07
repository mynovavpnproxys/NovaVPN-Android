import 'dart:async';

enum NovaAppState {
  initializing,
  ready,
  loading,
  error,
}

class AppStateService {
  NovaAppState _state = NovaAppState.initializing;

  final StreamController<NovaAppState> _stateController =
      StreamController<NovaAppState>.broadcast();

  NovaAppState get state => _state;

  Stream<NovaAppState> get stateStream => _stateController.stream;

  void setState(NovaAppState state) {
    _state = state;
    _stateController.add(state);
  }

  void dispose() {
    _stateController.close();
  }
}
