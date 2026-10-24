import 'dart:convert';

import '../models/nova_server.dart';

/// Parses common share links into the metadata NovaVPN needs to display and
/// select a server. The original URI is preserved for the native core.
class ImportManager {
  NovaServer? parse(String input) {
    final value = input.trim();
    if (value.isEmpty) return null;

    if (value.toLowerCase().startsWith('vmess://')) {
      return _parseVmess(value);
    }

    final uri = Uri.tryParse(value);
    if (uri == null) return null;

    final protocol = switch (uri.scheme.toLowerCase()) {
      'vless' => 'VLESS',
      'trojan' => 'Trojan',
      'ss' => 'Shadowsocks',
      'hysteria2' || 'hy2' => 'Hysteria2',
      'tuic' => 'TUIC',
      _ => null,
    };
    if (protocol == null || uri.host.isEmpty) return null;

    final port = uri.hasPort ? uri.port : 0;
    if (port < 1 || port > 65535) return null;

    final query = uri.queryParameters;
    final security = (query['security'] ?? query['tls'] ?? '').toLowerCase();
    final transport = (query['type'] ?? query['network'] ?? '').toLowerCase();
    final fragmentName = uri.hasFragment
        ? Uri.decodeComponent(uri.fragment).trim()
        : '';
    final name = fragmentName.isNotEmpty ? fragmentName : protocol;

    return NovaServer(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      protocol: protocol,
      address: uri.host,
      port: port,
      security: security.isEmpty
          ? (protocol == 'Trojan' || protocol == 'Hysteria2' || protocol == 'TUIC'
              ? 'tls'
              : 'unknown')
          : security,
      transport: transport.isEmpty ? 'tcp' : transport,
      tls: security == 'tls' ||
          security == 'reality' ||
          protocol == 'Trojan' ||
          protocol == 'Hysteria2' ||
          protocol == 'TUIC',
      rawConfig: value,
    );
  }

  NovaServer? _parseVmess(String value) {
    try {
      final encoded = value.substring('vmess://'.length).split('#').first;
      final normalized = base64Url.normalize(encoded);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final data = jsonDecode(decoded);
      if (data is! Map<String, dynamic>) return null;

      final host = (data['add'] ?? '').toString().trim();
      final port = int.tryParse((data['port'] ?? '').toString()) ?? 0;
      if (host.isEmpty || port < 1 || port > 65535) return null;

      final security = (data['tls'] ?? '').toString().toLowerCase();
      final transport = (data['net'] ?? 'tcp').toString().toLowerCase();
      final name = (data['ps'] ?? 'VMess').toString().trim();

      return NovaServer(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.isEmpty ? 'VMess' : name,
        protocol: 'VMess',
        address: host,
        port: port,
        security: security.isEmpty ? 'none' : security,
        transport: transport.isEmpty ? 'tcp' : transport,
        tls: security == 'tls',
        rawConfig: value,
      );
    } on FormatException {
      return null;
    } on JsonUnsupportedObjectError {
      return null;
    } catch (_) {
      return null;
    }
  }
}
