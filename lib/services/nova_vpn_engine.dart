import 'dart:convert';

import 'package:sing_box/sing_box.dart';

import '../models/nova_server.dart';
import 'import_manager.dart';

class NovaVpnEngine {
  final SingBox _engine = SingBox.instance;
  final ImportManager _importManager = ImportManager();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    final ready = await _engine.initialize();
    if (!ready) throw StateError('موتور VPN راه‌اندازی نشد.');
    _initialized = true;
  }

  Future<bool> connect(NovaServer server) async {
    await initialize();
    final config = _importManager.toSingBoxConfig(server);
    if (config == null) {
      throw FormatException('این لینک یا یکی از گزینه‌های آن هنوز قابل پشتیبانی نیست.');
    }
    return _engine.connect(jsonEncode(config));
  }

  Future<bool> disconnect() async {
    await initialize();
    return _engine.disconnect();
  }

  Future<bool> get isConnected async {
    await initialize();
    final status = await _engine.getConnectionStatus();
    return status.name == 'connected';
  }
}
