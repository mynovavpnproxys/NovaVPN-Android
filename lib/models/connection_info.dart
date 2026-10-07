class ConnectionInfo {
  final String serverId;
  final String serverName;
  final String protocol;
  final DateTime? connectedAt;
  final Duration? duration;
  final int? ping;
  final double? downloadSpeed;
  final double? uploadSpeed;

  const ConnectionInfo({
    required this.serverId,
    required this.serverName,
    required this.protocol,
    this.connectedAt,
    this.duration,
    this.ping,
    this.downloadSpeed,
    this.uploadSpeed,
  });
}
