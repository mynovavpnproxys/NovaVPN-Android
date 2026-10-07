class SelectionService {
  String? _selectedServerId;
  String? _selectedProfileId;

  String? get selectedServerId => _selectedServerId;
  String? get selectedProfileId => _selectedProfileId;

  void selectServer(String serverId) {
    _selectedServerId = serverId;
  }

  void selectProfile(String profileId) {
    _selectedProfileId = profileId;
  }

  void clearServerSelection() {
    _selectedServerId = null;
  }

  void clearProfileSelection() {
    _selectedProfileId = null;
  }

  void clearAll() {
    _selectedServerId = null;
    _selectedProfileId = null;
  }
}
