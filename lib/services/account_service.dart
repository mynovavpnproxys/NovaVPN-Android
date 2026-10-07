class AccountService {
  String? _userId;
  String? _telegramUserId;
  bool _isPremium = false;

  String? get userId => _userId;
  String? get telegramUserId => _telegramUserId;
  bool get isPremium => _isPremium;

  void setUser({
    required String userId,
    String? telegramUserId,
  }) {
    _userId = userId;
    _telegramUserId = telegramUserId;
  }

  void setPremium(bool value) {
    _isPremium = value;
  }

  void signOut() {
    _userId = null;
    _telegramUserId = null;
    _isPremium = false;
  }
}
