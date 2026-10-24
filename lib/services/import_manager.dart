import 'dart:convert';

import '../models/nova_server.dart';

/// Parses common proxy share links and converts supported links to sing-box JSON.
class ImportManager {
  NovaServer? parse(String input) {
    final value = input.trim();
    if (value.isEmpty) return null;

    if (value.toLowerCase().startsWith('vmess://')) {
      return _parseVmess(value);
    }

    final uri = Uri.tryParse(value);
    if (uri == null || uri.host.isEmpty) return null;

    final protocol = switch (uri.scheme.toLowerCase()) {
      'vless' => 'VLESS',
      'trojan' => 'Trojan',
      'ss' => 'Shadowsocks',
      'hysteria2' || 'hy2' => 'Hysteria2',
      'tuic' => 'TUIC',
      _ => null,
    };
    if (protocol == null) return null;

    final port = uri.hasPort ? uri.port : 0;
    if (port < 1 || port > 65535) return null;

    final query = uri.queryParameters;
    final security = (query['security'] ?? query['tls'] ?? '').toLowerCase();
    final transport = (query['type'] ?? query['network'] ?? 'tcp').toLowerCase();
    final fragmentName = uri.hasFragment ? uri.fragment.trim() : '';
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
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(encoded)));
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
    } catch (_) {
      return null;
    }
  }

  /// Returns null for protocols or options that cannot yet be represented safely.
  Map<String, dynamic>? toSingBoxConfig(NovaServer server) {
    final raw = server.rawConfig;
    if (raw == null || raw.isEmpty) return null;
    final uri = Uri.tryParse(raw);
    if (uri == null) return null;

    Map<String, dynamic>? outbound;
    switch (server.protocol) {
      case 'VLESS':
        final uuid = uri.userInfo.split(':').first;
        if (uuid.isEmpty || !_looksLikeUuid(uuid)) return null;
        final query = uri.queryParameters;
        final security = (query['security'] ?? 'none').toLowerCase();
        // Reality needs a public key; emitting an empty key produces a broken profile.
        if (security == 'reality' &&
            (query['pbk'] ?? query['publicKey'] ?? '').trim().isEmpty) {
          return null;
        }
        outbound = {
          'type': 'vless',
          'tag': 'proxy',
          'server': server.address,
          'server_port': server.port,
          'uuid': uuid,
          if ((query['flow'] ?? '').isNotEmpty) 'flow': query['flow'],
        };
        if (security == 'tls' || security == 'reality') {
          outbound['tls'] = {
            'enabled': true,
            'server_name': query['sni'] ?? query['serverName'] ?? server.address,
            if ((query['fp'] ?? '').isNotEmpty)
              'utls': {'enabled': true, 'fingerprint': query['fp']},
            if (security == 'reality')
              'reality': {
                'enabled': true,
                'public_key': query['pbk'] ?? query['publicKey'] ?? '',
                'short_id': query['sid'] ?? query['shortId'] ?? '',
              },
          };
        }
        _applyTransport(outbound, query['type'] ?? 'tcp', query);
        break;
      case 'VMess':
        final encoded = raw.substring('vmess://'.length).split('#').first;
        final data = jsonDecode(utf8.decode(
          base64Url.decode(base64Url.normalize(encoded)),
        )) as Map<String, dynamic>;
        final uuid = (data['id'] ?? '').toString().trim();
        if (!_looksLikeUuid(uuid)) return null;
        outbound = {
          'type': 'vmess',
          'tag': 'proxy',
          'server': server.address,
          'server_port': server.port,
          'uuid': uuid,
          'security': (data['scy'] ?? data['security'] ?? 'auto').toString(),
          'alter_id': int.tryParse((data['aid'] ?? '0').toString()) ?? 0,
        };
        if (server.tls) {
          outbound['tls'] = {
            'enabled': true,
            'server_name': (data['sni'] ?? data['host'] ?? server.address).toString(),
          };
        }
        _applyTransport(outbound, server.transport, {
          'host': data['host'] ?? '',
          'path': data['path'] ?? '/',
        });
        break;
      case 'Trojan':
        final password = uri.userInfo;
        if (password.isEmpty) return null;
        outbound = {
          'type': 'trojan',
          'tag': 'proxy',
          'server': server.address,
          'server_port': server.port,
          'password': password,
          'tls': {
            'enabled': true,
            'server_name': uri.queryParameters['sni'] ?? server.address,
          },
        };
        _applyTransport(outbound, uri.queryParameters['type'] ?? 'tcp', uri.queryParameters);
        break;
      case 'Shadowsocks':
        final authority = uri.userInfo;
        if (authority.isEmpty) return null;
        final decodedAuthority = _decodeShadowsocksAuthority(authority);
        if (decodedAuthority == null) return null;
        final parts = decodedAuthority.split(':');
        if (parts.length < 2) return null;
        outbound = {
          'type': 'shadowsocks',
          'tag': 'proxy',
          'server': server.address,
          'server_port': server.port,
          'method': parts.first,
          'password': parts.sublist(1).join(':'),
        };
        break;
      case 'Hysteria2':
        final password = uri.userInfo;
        if (password.isEmpty) return null;
        outbound = {
          'type': 'hysteria2',
          'tag': 'proxy',
          'server': server.address,
          'server_port': server.port,
          'password': password,
          'tls': {
            'enabled': true,
            'server_name': uri.queryParameters['sni'] ?? server.address,
            if ((uri.queryParameters['insecure'] ?? '') == '1')
              'insecure': true,
          },
        };
        break;
      case 'TUIC':
        final credentials = uri.userInfo.split(':');
        if (credentials.length < 2) return null;
        outbound = {
          'type': 'tuic',
          'tag': 'proxy',
          'server': server.address,
          'server_port': server.port,
          'uuid': credentials.first,
          'password': credentials.sublist(1).join(':'),
          'tls': {
            'enabled': true,
            'server_name': uri.queryParameters['sni'] ?? server.address,
          },
          'congestion_control': uri.queryParameters['congestion_control'] ?? 'bbr',
          'udp_relay_mode': uri.queryParameters['udp_relay_mode'] ?? 'native',
        };
        break;
      default:
        return null;
    }

    if ((outbound['server'] as String?)?.isEmpty ?? true) return null;
    return {
      'log': {'level': 'warn'},
      'dns': {
        'servers': [
          {'type': 'udp', 'tag': 'dns-remote', 'server': '1.1.1.1'},
        ],
        'final': 'dns-remote',
      },
      'inbounds': [
        {
          'type': 'tun',
          'tag': 'tun-in',
          'address': ['172.19.0.1/30', 'fdfe:dcba:9876::1/126'],
          'auto_route': true,
          'strict_route': true,
          'stack': 'mixed',
        },
      ],
      'outbounds': [
        outbound,
        {'type': 'direct', 'tag': 'direct'},
        {'type': 'block', 'tag': 'block'},
      ],
      'route': {
        'auto_detect_interface': true,
        'final': 'proxy',
        'rules': [
          {'protocol': 'dns', 'action': 'hijack-dns'},
        ],
      },
    };
  }

  bool _looksLikeUuid(String value) =>
      RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-8][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}    Map<String, dynamic> outbound,
    String transport,
    Map<String, dynamic> query,
  ) {
    switch (transport.toLowerCase()) {
      case 'ws':
        outbound['transport'] = {
          'type': 'ws',
          'path': query['path'] ?? '/',
          if ((query['host'] ?? query['host_header'] ?? '').toString().isNotEmpty)
            'headers': {
              'Host': (query['host'] ?? query['host_header']).toString(),
            },
        };
        break;
      case 'grpc':
        outbound['transport'] = {
          'type': 'grpc',
          'service_name': query['serviceName'] ?? query['service_name'] ?? '',
        };
        break;
      case 'http':
      case 'h2':
        outbound['transport'] = {
          'type': 'http',
          'path': query['path'] ?? '/',
          if ((query['host'] ?? '').toString().isNotEmpty)
            'host': [query['host'].toString()],
        };
        break;
      case 'tcp':
      case '':
        break;
      default:
        // Unknown transport parameters should not be silently misrepresented.
        outbound['transport'] = {'type': transport};
    }
  }

  String? _decodeShadowsocksAuthority(String authority) {
    try {
      final value = authority.contains('@')
          ? authority.substring(0, authority.lastIndexOf('@'))
          : authority;
      if (value.contains(':')) return value;
      return utf8.decode(base64Url.decode(base64Url.normalize(value)));
    } catch (_) {
      return null;
    }
  }
}
)
          .hasMatch(value);

  void _applyTransport(
    Map<String, dynamic> outbound,
    String transport,
    Map<String, dynamic> query,
  ) {
    switch (transport.toLowerCase()) {
      case 'ws':
        outbound['transport'] = {
          'type': 'ws',
          'path': query['path'] ?? '/',
          if ((query['host'] ?? query['host_header'] ?? '').toString().isNotEmpty)
            'headers': {
              'Host': (query['host'] ?? query['host_header']).toString(),
            },
        };
        break;
      case 'grpc':
        outbound['transport'] = {
          'type': 'grpc',
          'service_name': query['serviceName'] ?? query['service_name'] ?? '',
        };
        break;
      case 'http':
      case 'h2':
        outbound['transport'] = {
          'type': 'http',
          'path': query['path'] ?? '/',
          if ((query['host'] ?? '').toString().isNotEmpty)
            'host': [query['host'].toString()],
        };
        break;
      case 'tcp':
      case '':
        break;
      default:
        // Unknown transport parameters should not be silently misrepresented.
        outbound['transport'] = {'type': transport};
    }
  }

  String? _decodeShadowsocksAuthority(String authority) {
    try {
      final value = authority.contains('@')
          ? authority.substring(0, authority.lastIndexOf('@'))
          : authority;
      if (value.contains(':')) return value;
      return utf8.decode(base64Url.decode(base64Url.normalize(value)));
    } catch (_) {
      return null;
    }
  }
}
