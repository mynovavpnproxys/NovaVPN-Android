class SettingsService {
  bool _autoConnect = false;
  bool _vpnPerApp = false;

  bool get autoConnect => _autoConnect;
  bool get vpnPerApp => _vpnPerApp;

  void setAutoConnect(bool value) {
    _autoConnect = value;
  }

  void setVpnPerApp(bool value) {
    _vpnPerApp = value;
  }
}
