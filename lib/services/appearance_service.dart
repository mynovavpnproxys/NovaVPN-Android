import 'dart:async';

enum NovaThemeMode {
  dark,
  light,
  system,
}

class AppearanceService {
  NovaThemeMode _themeMode = NovaThemeMode.dark;

  final StreamController<NovaThemeMode> _themeController =
      StreamController<NovaThemeMode>.broadcast();

  NovaThemeMode get themeMode => _themeMode;

  Stream<NovaThemeMode> get themeStream => _themeController.stream;

  void setThemeMode(NovaThemeMode mode) {
    _themeMode = mode;
    _themeController.add(mode);
  }

  void dispose() {
    _themeController.close();
  }
}
