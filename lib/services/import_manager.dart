import '../models/nova_server.dart';

class ImportManager {
  NovaServer? parse(String input) {
    final value = input.trim();

    if (value.isEmpty) {
      return null;
    }

    if (value.startsWith('vless://')) {
      return _createServer(value, 'VLESS');
    }

    if (value.startsWith('vmess://')) {
      return _createServer(value, 'VMess');
    }

    if (value.startsWith('trojan://')) {
      return _createServer(value, 'Trojan');
    }

    if (value.startsWith('ss://')) {
      return _createServer(value, 'Shadowsocks');
    }

    if (value.startsWith('hysteria2://')) {
      return _createServer(value, 'Hysteria2');
    }

    if (value.startsWith('tuic://')) {
      return _createServer(value, 'TUIC');
    }

    return null;
  }

  NovaServer _createServer(String rawConfig, String protocol) {
    return NovaServer(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: 'Imported Server',
      protocol: protocol,
      address: '',
      port: 0,
      security: 'unknown',
      transport: 'unknown',
      tls: false,
      rawConfig: rawConfig,
    );
  }
}
