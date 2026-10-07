import '../models/nova_server.dart';

class ServerRepository {
  final List<NovaServer> _servers = [];

  List<NovaServer> get servers => List.unmodifiable(_servers);

  NovaServer? get selectedServer {
    if (_servers.isEmpty) {
      return null;
    }
    return _servers.first;
  }

  void addServer(NovaServer server) {
    _servers.add(server);
  }

  void removeServer(String id) {
    _servers.removeWhere((server) => server.id == id);
  }

  void clearServers() {
    _servers.clear();
  }
}
