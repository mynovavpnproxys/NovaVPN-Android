import 'package:flutter/services.dart';

class AndroidVpnBridge {
  static const MethodChannel _channel =
      MethodChannel('com.novavpn/vpn');

  Future<bool> connect() async {
    final result = await _channel.invokeMethod<bool>('connect');
    return result ?? false;
  }

  Future<bool> disconnect() async {
    final result = await _channel.invokeMethod<bool>('disconnect');
    return result ?? false;
  }

  Future<bool> isConnected() async {
    final result = await _channel.invokeMethod<bool>('isConnected');
    return result ?? false;
  }
}
