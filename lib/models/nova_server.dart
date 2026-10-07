class NovaServer {
  final String id;
  final String name;
  final String protocol;
  final String address;
  final int port;
  final String security;
  final String transport;
  final bool tls;
  final String? subscriptionId;
  final String? rawConfig;

  const NovaServer({
    required this.id,
    required this.name,
    required this.protocol,
    required this.address,
    required this.port,
    required this.security,
    required this.transport,
    required this.tls,
    this.subscriptionId,
    this.rawConfig,
  });
}
