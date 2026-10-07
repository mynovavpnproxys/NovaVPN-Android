import '../models/nova_profile.dart';

class ProfileRepository {
  final List<NovaProfile> _profiles = [];

  List<NovaProfile> get profiles => List.unmodifiable(_profiles);

  NovaProfile? get selectedProfile {
    if (_profiles.isEmpty) {
      return null;
    }

    return _profiles.first;
  }

  void addProfile(NovaProfile profile) {
    _profiles.add(profile);
  }

  void removeProfile(String id) {
    _profiles.removeWhere((profile) => profile.id == id);
  }

  void clearProfiles() {
    _profiles.clear();
  }
}
