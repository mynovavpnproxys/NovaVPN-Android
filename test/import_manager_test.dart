import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:novavpn/services/import_manager.dart';

void main() {
  final parser = ImportManager();

  test('rejects empty and unsupported links', () {
    expect(parser.parse(''), isNull);
    expect(parser.parse('https://example.com'), isNull);
    expect(parser.parse('vless://host-without-port'), isNull);
  });

  test('parses VLESS metadata and creates a sing-box config', () {
    const link = 'vless://123e4567-e89b-12d3-a456-426614174000@edge.example.com:443?security=tls&type=ws&sni=edge.example.com&path=%2Fvpn#Office';
    final server = parser.parse(link);
    expect(server, isNotNull);
    expect(server!.protocol, 'VLESS');
    expect(server.address, 'edge.example.com');
    expect(server.port, 443);
    expect(server.name, 'Office');
    expect(server.tls, isTrue);
    final config = parser.toSingBoxConfig(server);
    expect(config, isNotNull);
    final outbounds = config!['outbounds'] as List;
    expect((outbounds.first as Map)['type'], 'vless');
    expect((outbounds.first as Map)['uuid'], '123e4567-e89b-12d3-a456-426614174000');
    expect(((outbounds.first as Map)['transport'] as Map)['type'], 'ws');
  });

  test('parses VMess JSON share links', () {
    final payload = base64Url.encode(utf8.encode(jsonEncode({
      'v': '2', 'ps': 'VMess Test', 'add': 'vmess.example.com',
      'port': '8443', 'id': '123e4567-e89b-12d3-a456-426614174000',
      'net': 'ws', 'tls': 'tls',
    })));
    final server = parser.parse('vmess://$payload');
    expect(server, isNotNull);
    expect(server!.protocol, 'VMess');
    expect(server.address, 'vmess.example.com');
    expect(server.port, 8443);
    expect(parser.toSingBoxConfig(server), isNotNull);
  });

  test('parses Trojan and Hysteria2 metadata', () {
    final trojan = parser.parse('trojan://secret@trojan.example.com:443?sni=trojan.example.com#Trojan');
    final hysteria = parser.parse('hysteria2://secret@hy.example.com:8443?sni=hy.example.com#HY2');
    expect(trojan?.tls, isTrue);
    expect(parser.toSingBoxConfig(trojan!), isNotNull);
    expect(hysteria?.port, 8443);
    expect(parser.toSingBoxConfig(hysteria!), isNotNull);
  });

  test('rejects invalid ports', () {
    expect(parser.parse('trojan://secret@example.com:70000'), isNull);
    expect(parser.parse('trojan://secret@example.com:0'), isNull);
  });

  test('rejects VLESS Reality links without a public key', () {
    const link =
        'vless://123e4567-e89b-12d3-a456-426614174000@edge.example.com:443?security=reality&sid=abcd#Reality';
    final server = parser.parse(link);
    expect(server, isNotNull);
    expect(parser.toSingBoxConfig(server!), isNull);
  });

  test('rejects malformed VLESS and VMess UUIDs', () {
    const vless = 'vless://not-a-uuid@edge.example.com:443?security=tls';
    final vmessPayload = base64Url.encode(utf8.encode(jsonEncode({
      'v': '2', 'ps': 'Bad VMess', 'add': 'vmess.example.com',
      'port': '443', 'id': 'not-a-uuid', 'net': 'tcp',
    })));
    final vlessServer = parser.parse(vless);
    final vmessServer = parser.parse('vmess://$vmessPayload');
    expect(vlessServer, isNotNull);
    expect(parser.toSingBoxConfig(vlessServer!), isNull);
    expect(vmessServer, isNotNull);
    expect(parser.toSingBoxConfig(vmessServer!), isNull);
  });

  test('accepts VLESS Reality when its public key is present', () {
    const link =
        'vless://123e4567-e89b-12d3-a456-426614174000@edge.example.com:443?security=reality&pbk=publicKeyValue&sid=abcd&sni=edge.example.com&type=tcp#Reality';
    final server = parser.parse(link);
    expect(server, isNotNull);
    final config = parser.toSingBoxConfig(server!);
    expect(config, isNotNull);
    final outbound = (config!['outbounds'] as List).first as Map;
    final tls = outbound['tls'] as Map;
    final reality = tls['reality'] as Map;
    expect(reality['public_key'], 'publicKeyValue');
    expect(reality['short_id'], 'abcd');
  });

}
