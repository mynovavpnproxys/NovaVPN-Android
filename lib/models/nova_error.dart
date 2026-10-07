enum NovaErrorType {
  vpnPermission,
  network,
  server,
  configuration,
  core,
  authentication,
  unknown,
}

class NovaError {
  final NovaErrorType type;
  final String message;
  final String? code;

  const NovaError({
    required this.type,
    required this.message,
    this.code,
  });
}
