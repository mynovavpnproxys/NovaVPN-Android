import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/nova_server.dart';

/// Stores imported share links locally on the device.
class ServerRepository {
  static const _storageKey = 'nova_vpn_servers_v1';
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<NovaServer>> loadServers() async {
    final raw = await _preferences.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_fromJson)
          .toList(growable: false);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveServers(List<NovaServer> servers) async {
    await _preferences.setString(
      _storageKey,
      jsonEncode(servers.map(_toJson).toList()),
    );
  }

  Map<String, dynamic> _toJson(NovaServer server) => {
        'id': server.id,
        'name': server.name,
        'protocol': server.protocol,
        'address': server.address,
        'port': server.port,
        'security': server.security,
        'transport': server.transport,
        'tls': server.tls,
        'subscriptionId': server.subscriptionId,
        'rawConfig': server.rawConfig,
      };

  NovaServer _fromJson(Map<String, dynamic> json) => NovaServer(
        id: json['id'] as String,
        name: json['name'] as String,
        protocol: json['protocol'] as String,
        address: json['address'] as String,
        port: (json['port'] as num).toInt(),
        security: json['security'] as String? ?? 'unknown',
        transport: json['transport'] as String? ?? 'tcp',
        tls: json['tls'] as bool? ?? false,
        subscriptionId: json['subscriptionId'] as String?,
        rawConfig: json['rawConfig'] as String?,
      );
}
